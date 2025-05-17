configuration RTL_TEST of t_dp_mem is
  for test
    for UUT:dp_mem
      use entity WORK.dp_mem(RTL);
    end for;
  end for;
end RTL_TEST;

configuration COREGEN_TEST of t_dp_mem is
  for test
    for UUT:dp_mem
      use entity WORK.dp_mem(dp_mem_a);
    end for;
  end for;
end COREGEN_TEST;

