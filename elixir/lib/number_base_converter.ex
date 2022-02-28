defmodule NumberBaseConverter do
  @lower_case_alphabet Enum.to_list(?a..?z)
                       |> Enum.map(fn letter_code -> <<letter_code>> end)

  @spec valid_number?(String.t()) :: boolean()
  def valid_number?(number) do
    regex = ~r/^[-]?[a-zA-Z1-9][a-zA-Z0-9]*$/
    Regex.match?(regex, number)
  end

  @spec valid_single_digit_number?(String.t()) :: boolean()
  def valid_single_digit_number?(number) do
    regex = ~r/^[a-z0-9]{1}$/
    Regex.match?(regex, number)
  end

  @spec valid_number_base?(String.t(), 2..36) :: boolean()
  def valid_number_base?(number, base) do
    if base not in 2..36 do
      raise ArgumentError, "Only bases between 2 and 36 are accepted"
    end

    max_value = base - 1

    String.graphemes(number)
    |> Enum.map(fn digit ->
      isolated_digit_value = convert_string_numeric_value(digit)
      if isolated_digit_value > max_value, do: :invalid
    end)
    # TODO: Testar se o valor esta sendo mesmo invertido
    |> then(&(not Enum.member?(&1, :invalid)))
  end

  @spec convert_string_numeric_value(String.t()) :: integer()
  def convert_string_numeric_value(character) when byte_size(character) == 1 do
    if not valid_single_digit_number?(character) do
      raise ArgumentError, "Only bases between 2 and 36 are accepted"
    end

    is_letter =
      Integer.parse(character)
      |> is_atom()

    if is_letter do
      letter_index = Enum.find_index(@lower_case_alphabet, fn value -> value == character end)
      _numeric_value = letter_index + 10
    else
      _numeric_value = String.to_integer(character)
    end
  end

  @spec convert_number_to_single_digit_string(0..35) :: String.t()
  def convert_number_to_single_digit_string(number) do
    if number not in 0..35 do
      raise ArgumentError, "Only numbers between 0 and 35 are accepted"
    end

    # Since numbers bigger than 9 will be represented as a letter, and the
    # alphabet only has 26 letters, the number needs to be between 10 (which
    # represents the letter "a") and 10 + the 25 remaining alphabet characters
    cond do
      number in 10..35 -> Enum.at(@lower_case_alphabet, number - 10)
      number in 0..9 -> Integer.to_string(number)
    end
  end

  @spec process_number(String.t()) :: {String.t(), boolean()}
  defp process_number(number) do
    is_negative = if String.starts_with?(number, "-"), do: true, else: false

    number =
      if is_negative do
        ending = String.length(number) - 1
        String.slice(number, 1..ending)
      else
        number
      end
      |> String.downcase()

    {number, is_negative}
  end

  @spec validate_convertion(String.t(), integer(), integer()) :: nil
  defp validate_convertion(number, _from_base, _to_base)
       when not is_binary(number) do
    raise ArgumentError, "The number to convert must be of type string"
  end

  defp validate_convertion(_number, from_base, to_base)
       # Elixir doesn't make any sense because the next line means "from_base is
       # not number or to_base is not number" instead of "from_base is not
       # number or to_base is number"
       when not is_integer(from_base) or not is_integer(to_base) do
    raise ArgumentError, "Bases must be integers"
  end

  defp validate_convertion(_number, _from_base, to_base)
       when to_base not in 2..36 do
    raise ArgumentError, "Only bases between 2 and 36 are accepted"
  end

  defp validate_convertion(number, from_base, _to_base) do
    if not valid_number?(number) do
      raise ArgumentError,
            "\"#{number}\" is not a valid number\n" <>
              "Hint: Numbers should not start with 0"
    end

    if not valid_number_base?(number, from_base) do
      raise ArgumentError, "The number #{number} can't be base #{from_base}"
    end
  end

  @spec convert_to_base_10(String.t(), integer()) :: integer()
  defp convert_to_base_10(number, from_base) do
    _base_10_conversion =
      Utilities.string_to_list(number)
      |> Enum.reverse()
      |> Utilities.add_index_for_each_item()
      |> Enum.map(fn {digit, index} ->
        isolated_digit_value = convert_string_numeric_value(digit)
        isolated_digit_value * from_base ** index
      end)
      |> Enum.sum()
  end

  @spec convert_number_base(String.t(), integer(), integer()) :: String.t()
  def convert_number_base(number, from_base \\ 2, to_base \\ 10)

  def convert_number_base(number, from_base, to_base)
      when from_base == to_base or number == 0 do
    validate_convertion(number, from_base, to_base)

    number
  end

  def convert_number_base(number, from_base, 10) do
    {number, is_negative} = process_number(number)

    validate_convertion(number, from_base, 10)

    base_10_conversion = convert_to_base_10(number, from_base)

    if is_negative do
      "-#{base_10_conversion}"
    else
      Integer.to_string(base_10_conversion)
    end
  end

  def convert_number_base(number, from_base, to_base) do
    {number, is_negative} = process_number(number)

    validate_convertion(number, from_base, to_base)

    base_10_conversion = convert_to_base_10(number, from_base)
    conversion = convert_number_base_loop(base_10_conversion, "", to_base)

    if is_negative do
      "-#{conversion}"
    else
      conversion
    end
  end

  @spec convert_number_base_loop(integer(), String.t(), integer()) :: String.t()
  defp convert_number_base_loop(division_quotient, division_remainders, to_base) do
    if division_quotient != 0 do
      division_remainder = rem(division_quotient, to_base)

      division_remainders =
        division_remainders <>
          convert_number_to_single_digit_string(division_remainder)

      division_quotient = div(division_quotient, to_base)
      convert_number_base_loop(division_quotient, division_remainders, to_base)
    else
      String.reverse(division_remainders)
    end
  end
end
