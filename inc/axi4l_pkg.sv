package axi4l_pkg;

  `define AXI4L_AW_T(__NAME__, __AW__)          \
    typedef struct packed {                     \
        logic [``__AW__``-1:0] aw_addr;         \
        logic [2:0] aw_prot;                    \
        logic aw_valid;                         \
    } ``__NAME__``chan_t;                       \



  `define AXI4L_W_T(__NAME__, __DW__)           \
    typedef struct packed {                     \
        logic [``__DW__``-1:0]  w_data;         \
        logic [``__DW__``/8 - 1:0] w_strb;      \
        logic w_valid;                          \
    } ``__NAME__``;                             \



  `define AXI4L_B_T(__NAME__)                   \
    typedef struct packed {                     \
        logic [1:0]  b_resp;                    \
        logic b_ready;                          \
    } ``__NAME__``;                             \



  `define AXI4L_AR_T(__NAME__, __AW__)          \
    typedef struct packed {                     \
        logic [``__AW__``-1:0] ar_addr;         \
        logic [2:0] ar_prot;                    \
        logic ar_valid;                         \
    } ``__NAME__``;                             \



  `define AXI4L_R_T(__NAME__, __DW__)           \
    typedef struct packed {                     \
        logic [``__DW__``-1:0]  r_data;         \
        logic [1:0] r_resp;                     \
        logic r_valid;                          \
    } ``__NAME__``;                             \



  `define AXI4L_REQ_T()




endpackage
