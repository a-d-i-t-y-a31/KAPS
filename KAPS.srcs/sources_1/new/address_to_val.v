//We have to put a mux behind ram controller and ahead of the ram to select between the two different address sources

// Exa


// module address_to_val(
//     input  [7:0] X_data,
//     input  [7:0] W_data,
//     input  X_enable,
//     input  W_enable,
//     input  [23:0] X_addr,
//     input  [23:0] W_addr,
//     output [23:0] X_addr_out,
//     output [23:0] W_addr_out,
//     output [7:0] X_val,
//     output [7:0] W_val,
// );

//     assign X_val = (X_enable) ? X_data : 8'bz;
//     assign W_val = (W_enable) ? W_data : 8'bz;
//     assign X_addr_out = X_addr;
//     assign W_addr_out = W_addr;

// endmodule
