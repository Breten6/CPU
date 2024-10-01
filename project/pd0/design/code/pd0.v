module pd0(
  input clock,
  input reset
);
  /* demonstrating the usage of assign_and */
  reg assign_and_x;
  reg assign_and_y;
  wire assign_and_z;
  assign_and assign_and_0 (
    .x(assign_and_x),
    .y(assign_and_y),
    .z(assign_and_z)
  );

  /* Exercise 3.3 module/probes */
  reg ex33_x;
  reg ex33_y;
  wire ex33_z;
  reg  ex33_areset;
  reg_and_arst arst(.clock(clock),.areset(ex33_areset),.x(ex33_x),.y(ex33_y),.z(ex33_z));

  /* Exercise 3.4 module/probes */
  reg ex34_x;
  reg ex34_y;
  reg ex34_z;
  reg_and_reg and_reg(.clock(clock),.reset(reset),.x(ex34_x),.y(ex34_y),.z(ex34_z));
endmodule
