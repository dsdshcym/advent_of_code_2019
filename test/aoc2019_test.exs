defmodule AoC2019Test do
  use ExUnit.Case
  doctest AoC2019

  @input "1 ZQVND => 2 MBZM
2 KZCVX, 1 SZBQ => 7 HQFB
1 PFSQF => 9 RSVN
2 PJXQB => 4 FSNZ
20 JVDKQ, 2 LSQFK, 8 SDNCK, 1 MQJNV, 13 LBTV, 3 KPBRX => 5 QBPC
131 ORE => 8 WDQSL
19 BRGJH, 2 KNVN, 3 CRKW => 9 MQJNV
16 DNPM, 1 VTVBF, 11 JSGM => 1 BWVJ
3 KNVN, 1 JQRML => 7 HGQJ
1 MRQJ, 2 HQFB, 1 MQJNV => 5 VQLP
1 PLGH => 5 DMGF
12 DMGF, 3 DNPM, 1 CRKW => 1 CLML
1 JSGM, 1 RSVN => 5 TMNKH
1 RFJLG, 3 CFWC => 2 ZJMC
1 BRGJH => 5 KPBRX
1 SZBQ, 17 GBVJF => 4 ZHGL
2 PLGH => 5 CFWC
4 FCBZS, 2 XQWHB => 8 JSGM
2 PFSQF => 2 KNVN
12 CRKW, 9 GBVJF => 1 KRCB
1 ZHGL => 8 PJMFP
198 ORE => 2 XQWHB
2 BWVJ, 7 CFWC, 17 DPMWN => 3 KZCVX
4 WXBF => 6 JVDKQ
2 SWMTK, 1 JQRML => 7 QXGZ
1 JSGM, 1 LFSFJ => 4 LSQFK
73 KNVN, 65 VQLP, 12 QBPC, 4 XGTL, 10 SWMTK, 51 ZJMC, 4 JMCPR, 1 VNHT => 1 FUEL
1 BWVJ, 7 MBZM => 5 JXZT
10 CFWC => 2 DPMWN
13 LQDLN => 3 LBTV
1 PFZW, 3 LQDLN => 5 PJXQB
2 RSVN, 2 PFSQF => 5 CRKW
1 HGQJ, 3 SMNGJ, 36 JXZT, 10 FHKG, 3 KPBRX, 2 CLML => 3 JMCPR
126 ORE => 4 FCBZS
1 DNPM, 13 MBZM => 5 PLGH
2 XQWHB, 10 FCBZS => 9 LFSFJ
1 DPMWN => 9 PFZW
1 ZJMC, 3 TMNKH => 2 SWMTK
7 TZCK, 1 XQWHB => 5 ZQVND
4 CFWC, 1 ZLWN, 5 RSVN => 2 WXBF
1 BRGJH, 2 CLML => 6 LQDLN
26 BWVJ => 2 GBVJF
16 PJXQB, 20 SDNCK, 3 HQFB, 7 QXGZ, 2 KNVN, 9 KZCVX => 8 XGTL
8 PJMFP, 3 BRGJH, 19 MRQJ => 5 SMNGJ
7 DNPM => 2 SZBQ
2 JQRML, 14 SDNCK => 8 FHKG
1 FSNZ, 6 RFJLG, 2 CRKW => 8 SDNCK
2 CLML, 4 SWMTK, 16 KNVN => 4 JQRML
8 TZCK, 18 WDQSL => 2 PFSQF
1 LSQFK => 8 VTVBF
18 BRGJH, 8 ZHGL, 2 KRCB => 7 VNHT
3 TZCK => 4 DNPM
14 PFZW, 1 PFSQF => 7 BRGJH
21 PLGH, 6 VTVBF, 2 RSVN => 1 ZLWN
149 ORE => 2 TZCK
3 JSGM => 1 RFJLG
4 PFSQF, 4 DMGF => 3 MRQJ"

  describe "to_menu/1" do
    test "example" do
      input = "10 ORE => 10 A
1 ORE => 1 B
7 A, 1 B => 1 C
7 A, 1 C => 1 D
7 A, 1 D => 1 E
7 A, 1 E => 1 FUEL"

      assert AoC2019.to_menu(input) == %{
               {"FUEL", 1} => [{"A", 7}, {"E", 1}],
               {"E", 1} => [{"A", 7}, {"D", 1}],
               {"D", 1} => [{"A", 7}, {"C", 1}],
               {"C", 1} => [{"A", 7}, {"B", 1}],
               {"B", 1} => [{"ORE", 1}],
               {"A", 10} => [{"ORE", 10}]
             }
    end
  end

  describe "part 1" do
    test "31 ORE for 1 FUEL:" do
      input = "10 ORE => 10 A
1 ORE => 1 B
7 A, 1 B => 1 C
7 A, 1 C => 1 D
7 A, 1 D => 1 E
7 A, 1 E => 1 FUEL"

      assert AoC2019.p1(input) == 31
    end

    test "considers topological cases" do
      input = "9 ORE => 2 A
8 ORE => 3 B
7 ORE => 5 C
3 A, 4 B => 1 AB
5 AB, 7 C => 1 BC
4 BC, 1 A => 1 CA
2 AB, 3 BC, 4 CA => 1 FUEL"

      assert AoC2019.p1(input) == 2561
    end

    test "165 ORE for 1 FUEL:" do
      input = "9 ORE => 2 A
8 ORE => 3 B
7 ORE => 5 C
3 A, 4 B => 1 AB
5 B, 7 C => 1 BC
4 C, 1 A => 1 CA
2 AB, 3 BC, 4 CA => 1 FUEL"

      assert AoC2019.p1(input) == 165
    end

    test "13312 ORE for 1 FUEL:" do
      input = "157 ORE => 5 NZVS
165 ORE => 6 DCFZ
44 XJWVT, 5 KHKGT, 1 QDVJ, 29 NZVS, 9 GPVTF, 48 HKGWZ => 1 FUEL
12 HKGWZ, 1 GPVTF, 8 PSHF => 9 QDVJ
179 ORE => 7 PSHF
177 ORE => 5 HKGWZ
7 DCFZ, 7 PSHF => 2 XJWVT
165 ORE => 2 GPVTF
3 DCFZ, 7 NZVS, 5 HKGWZ, 10 PSHF => 8 KHKGT"

      assert AoC2019.p1(input) == 13312
    end

    test "180697 ORE for 1 FUEL:" do
      input = "2 VPVL, 7 FWMGM, 2 CXFTF, 11 MNCFX => 1 STKFG
17 NVRVD, 3 JNWZP => 8 VPVL
53 STKFG, 6 MNCFX, 46 VJHF, 81 HVMC, 68 CXFTF, 25 GNMV => 1 FUEL
22 VJHF, 37 MNCFX => 5 FWMGM
139 ORE => 4 NVRVD
144 ORE => 7 JNWZP
5 MNCFX, 7 RFSQX, 2 FWMGM, 2 VPVL, 19 CXFTF => 3 HVMC
5 VJHF, 7 MNCFX, 9 VPVL, 37 CXFTF => 6 GNMV
145 ORE => 6 MNCFX
1 NVRVD => 8 CXFTF
1 VJHF, 6 MNCFX => 4 RFSQX
176 ORE => 6 VJHF"

      assert AoC2019.p1(input) == 180_697
    end

    test "2210736 ORE for 1 FUEL:" do
      input = "171 ORE => 8 CNZTR
7 ZLQW, 3 BMBT, 9 XCVML, 26 XMNCP, 1 WPTQ, 2 MZWV, 1 RJRHP => 4 PLWSL
114 ORE => 4 BHXH
14 VRPVC => 6 BMBT
6 BHXH, 18 KTJDG, 12 WPTQ, 7 PLWSL, 31 FHTLT, 37 ZDVW => 1 FUEL
6 WPTQ, 2 BMBT, 8 ZLQW, 18 KTJDG, 1 XMNCP, 6 MZWV, 1 RJRHP => 6 FHTLT
15 XDBXC, 2 LTCX, 1 VRPVC => 6 ZLQW
13 WPTQ, 10 LTCX, 3 RJRHP, 14 XMNCP, 2 MZWV, 1 ZLQW => 1 ZDVW
5 BMBT => 4 WPTQ
189 ORE => 9 KTJDG
1 MZWV, 17 XDBXC, 3 XCVML => 2 XMNCP
12 VRPVC, 27 CNZTR => 2 XDBXC
15 KTJDG, 12 BHXH => 5 XCVML
3 BHXH, 2 VRPVC => 7 MZWV
121 ORE => 7 VRPVC
7 XCVML => 6 RJRHP
5 BHXH, 4 VRPVC => 5 LTCX"

      assert AoC2019.p1(input) == 2_210_736
    end

    test "test input" do
      assert AoC2019.p1(@input) == 1_582_325
    end
  end

  describe "part 2" do
    test "13312 ORE" do
      input = "157 ORE => 5 NZVS
165 ORE => 6 DCFZ
44 XJWVT, 5 KHKGT, 1 QDVJ, 29 NZVS, 9 GPVTF, 48 HKGWZ => 1 FUEL
12 HKGWZ, 1 GPVTF, 8 PSHF => 9 QDVJ
179 ORE => 7 PSHF
177 ORE => 5 HKGWZ
7 DCFZ, 7 PSHF => 2 XJWVT
165 ORE => 2 GPVTF
3 DCFZ, 7 NZVS, 5 HKGWZ, 10 PSHF => 8 KHKGT"

      assert AoC2019.p2(input) == 82_892_753
    end

    test "180697 ORE" do
      input = "2 VPVL, 7 FWMGM, 2 CXFTF, 11 MNCFX => 1 STKFG
17 NVRVD, 3 JNWZP => 8 VPVL
53 STKFG, 6 MNCFX, 46 VJHF, 81 HVMC, 68 CXFTF, 25 GNMV => 1 FUEL
22 VJHF, 37 MNCFX => 5 FWMGM
139 ORE => 4 NVRVD
144 ORE => 7 JNWZP
5 MNCFX, 7 RFSQX, 2 FWMGM, 2 VPVL, 19 CXFTF => 3 HVMC
5 VJHF, 7 MNCFX, 9 VPVL, 37 CXFTF => 6 GNMV
145 ORE => 6 MNCFX
1 NVRVD => 8 CXFTF
1 VJHF, 6 MNCFX => 4 RFSQX
176 ORE => 6 VJHF"

      assert AoC2019.p2(input) == 5_586_022
    end

    test "2210736 ORE" do
      input = "171 ORE => 8 CNZTR
7 ZLQW, 3 BMBT, 9 XCVML, 26 XMNCP, 1 WPTQ, 2 MZWV, 1 RJRHP => 4 PLWSL
114 ORE => 4 BHXH
14 VRPVC => 6 BMBT
6 BHXH, 18 KTJDG, 12 WPTQ, 7 PLWSL, 31 FHTLT, 37 ZDVW => 1 FUEL
6 WPTQ, 2 BMBT, 8 ZLQW, 18 KTJDG, 1 XMNCP, 6 MZWV, 1 RJRHP => 6 FHTLT
15 XDBXC, 2 LTCX, 1 VRPVC => 6 ZLQW
13 WPTQ, 10 LTCX, 3 RJRHP, 14 XMNCP, 2 MZWV, 1 ZLQW => 1 ZDVW
5 BMBT => 4 WPTQ
189 ORE => 9 KTJDG
1 MZWV, 17 XDBXC, 3 XCVML => 2 XMNCP
12 VRPVC, 27 CNZTR => 2 XDBXC
15 KTJDG, 12 BHXH => 5 XCVML
3 BHXH, 2 VRPVC => 7 MZWV
121 ORE => 7 VRPVC
7 XCVML => 6 RJRHP
5 BHXH, 4 VRPVC => 5 LTCX"

      assert AoC2019.p2(input) == 460_664
    end

    test "test input" do
      assert AoC2019.p2(@input) == 2_267_486
    end
  end
end
