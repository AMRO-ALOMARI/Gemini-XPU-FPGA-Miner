module mod_square_secp256k1 (
    input  logic         clk,
    input  logic         rst_n,
    input  logic         start,      // نبضة لبدء العملية
    input  logic [255:0] A,
    output logic [255:0] Z,
    output logic         done        // إشارة انتهاء الحساب
);

    // ثوابت SECP256k1 لعملية الـ Folding
    // P = 2^256 - 2^32 - 977
    localparam logic [255:0] P_CONST = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFC2F;
    localparam logic [32:0]  K_VAL   = 33'h1000003D1; // 2^32 + 977

    typedef enum logic [1:0] {IDLE, COMPUTE, REDUCE, FINISH} state_t;
    state_t state;

    logic [5:0]   counter;     // 64 دورة لضرب 256 بت (4 بت لكل دورة)
    logic [255:0] reg_a;       // تخزين المدخل A
    logic [511:0] accumulator; // سجل التراكم للضرب

    // --- منطق الحالة (FSM) والحساب الموفر للمساحة ---
    always_ff @(posedge clk) begin
        if (!rst_n) begin
            state       <= IDLE;
            done        <= 0;
            accumulator <= 0;
            counter     <= 0;
            Z           <= 0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 0;
                    if (start) begin
                        reg_a       <= A;
                        accumulator <= 0;
                        counter     <= 0;
                        state       <= COMPUTE;
                    end
                end

                COMPUTE: begin
                    // Radix-16: معالجة 4 بت في كل دورة
                    // هذا يقلل عرض الـ Multiplier إلى (256x4) فقط بدلاً من (256x256)
                    accumulator <= (accumulator << 4) + (reg_a * A[(63-counter)*4 +: 4]);
                    
                    if (counter == 63)
                        state <= REDUCE;
                    else
                        counter <= counter + 1;
                end

                REDUCE: begin
                    // مرحلة الاختزال السريع (Fast Reduction)
                    // تقليل الـ 512 بت إلى 256 بت باستخدام خاصية Solinas Prime
                    automatic logic [255:0] low  = accumulator[255:0];
                    automatic logic [255:0] high = accumulator[511:256];
                    automatic logic [288:0] fold1;

                    // Fold 1: L + H * (2^32 + 977)
                    fold1 = low + (high << 32) + (high * 10'd977);
                    
                    // Fold 2: معالجة الفائض الصغير الناتج عن الجمع الأول
                    accumulator[255:0] <= fold1[255:0] + (fold1[288:256] << 32) + (fold1[288:256] * 10'd977);
                    state <= FINISH;
                end

                FINISH: begin
                    // التحقق النهائي (Final Range Reduction)
                    if (accumulator[255:0] >= P_CONST)
                        Z <= accumulator[255:0] - P_CONST;
                    else
                        Z <= accumulator[255:0];
                        
                    done  <= 1;
                    state <= IDLE;
                end
                
                default: state <= IDLE;
            endcase
        end
    end

endmodule