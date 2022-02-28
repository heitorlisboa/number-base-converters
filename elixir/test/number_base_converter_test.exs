defmodule NumberBaseConverterTest do
  # TODO: Criar erro personalizado para intervalo (RangeError)
  use ExUnit.Case

  import NumberBaseConverter,
    only: [convert_number_base: 1, convert_number_base: 2, convert_number_base: 3]

  test "should throw `ArgumentError` when invalid character is passed" do
    convert_invalid_number = fn ->
      convert_number_base("87.5")
    end

    regex = ~r/not[\w\s]*valid[\w\s]*number/

    assert_raise(ArgumentError, regex, convert_invalid_number)
  end

  test "should throw `ArgumentError` when first numeric digit is zero" do
    convert_zero_as_first_numeric_digit = fn ->
      convert_number_base("-0")
    end

    regex = ~r/not[\w\s]*valid[\w\s]*number/

    assert_raise(ArgumentError, regex, convert_zero_as_first_numeric_digit)
  end

  test "should throw `ArgumentError` when number doesn't correspond the informed base" do
    base = 10

    convert_number_not_corresponding_base = fn ->
      convert_number_base("ff", base)
    end

    regex = ~r/(can't|isn't|not)[\w\s]*base #{base}/

    assert_raise(ArgumentError, regex, convert_number_not_corresponding_base)
  end

  test "should throw `ArgumentError` when `base_from` is greater than max" do
    convert_base_from_greater_than_max = fn ->
      convert_number_base("f", 37)
    end

    regex = ~r/2[\w\s]*36/

    assert_raise(ArgumentError, regex, convert_base_from_greater_than_max)
  end

  test "should throw `ArgumentError` when `base_from` is less than min" do
    convert_base_from_less_than_min = fn ->
      convert_number_base("f", 1)
    end

    regex = ~r/2[\w\s]*36/

    assert_raise(ArgumentError, regex, convert_base_from_less_than_min)
  end

  test "should throw `ArgumentError` when `base_to` is greater than max" do
    convert_base_to_greater_than_max = fn ->
      convert_number_base("1", 2, 37)
    end

    regex = ~r/2[\w\s]*36/

    assert_raise(ArgumentError, regex, convert_base_to_greater_than_max)
  end

  test "should throw `ArgumentError` when `base_to` is less than min" do
    convert_base_to_less_than_min = fn ->
      convert_number_base("1", 2, 1)
    end

    regex = ~r/2[\w\s]*36/

    assert_raise(ArgumentError, regex, convert_base_to_less_than_min)
  end

  test "should return a negative number when `base_to` is 10 and the number is negative" do
    converted_number = convert_number_base("-1", 2, 10)
    assert(converted_number == "-1")
  end

  test "should return a negative number when `base_to` is 16 and the number is negative" do
    converted_number = convert_number_base("-1", 2, 16)
    assert(converted_number == "-1")
  end

  test "should correctly convert from binary to decimal" do
    number = "1000"
    expected_conversion = "8"
    converted_number = convert_number_base(number, 2, 10)
    assert(converted_number == expected_conversion)
  end

  test "should correctly convert from decimal to binary" do
    number = "18"
    expected_conversion = "10010"
    converted_number = convert_number_base(number, 10, 2)
    assert(converted_number == expected_conversion)
  end

  test "should correctly convert when using uppercase letters" do
    number = "10F"
    expected_conversion = "271"
    converted_number = convert_number_base(number, 16, 10)
    assert(converted_number == expected_conversion)
  end
end
