from string import ascii_lowercase
from typing import Tuple
import re


def validate_number(number: str) -> bool:
    regex = r"^[-]?[a-zA-Z1-9][a-zA-Z0-9]*$"
    match = re.match(regex, number)

    return False if match == None else True


def validate_single_digit_number(number: str) -> bool:
    regex = r"^[a-z0-9]{1}$"
    match = re.match(regex, number)

    return False if match == None else True


def validate_number_base(number: str, base: int) -> bool:
    if not (2 <= base <= 36):
        raise ValueError("Only bases between 2 and 36 are accepted")

    max_value = base - 1

    valid = True
    for digit in number:
        isolated_digit_value = convert_string_numeric_value(digit)
        if isolated_digit_value > max_value:
            valid = False

    return valid


def convert_string_numeric_value(character: str) -> int:
    if len(character) != 1:
        raise ValueError("Insert only 1 character")
    if not validate_single_digit_number(character):
        raise ValueError(f"{character} is not a valid number")
    try:
        int(character)
    except:
        is_letter = True
    else:
        is_letter = False

    if is_letter:
        letter_index = ascii_lowercase.find(character)
        numeric_value = letter_index + 10
    else:
        numeric_value = int(character)

    return numeric_value


def convert_number_to_single_digit_string(number: int) -> str:
    # Since numbers bigger than 9 will be represented as a letter, and the
    # alphabet only has 26 letters, the number needs to be between 10 (which
    # represents the letter "a") and 10 + the 25 remaining alphabet characters
    if 10 <= number <= 10 + 25:
        return ascii_lowercase[number - 10]
    elif 0 <= number <= 9:
        return str(number)
    else:
        raise ValueError("Only numbers between 0 and 35 are accepted")


def _process_number(number: str) -> Tuple[str, bool]:
    number = number.lower()

    if number[0] == "-":
        number = number[1:]
        is_negative = True
    else:
        is_negative = False

    return (number, is_negative)


def convert_number_base(number: str, from_base: int = 2, to_base: int = 10) -> str:
    """
    Convert an integer (as a string) from any base between 2 and 36 to another
    base from the same range

    Parameters
    ----------
    `number` &mdash; Number to convert

    `from_base` &mdash; Number base to convert from (default = 2)

    `to_base` &mdash; Number base to convert to (default = 10)

    Returns
    -------
    The converted number
    """

    # Type validations
    if type(number) != str:
        raise TypeError("The number to convert must be of type string")
    if type(from_base) != int or type(to_base) != int:
        raise TypeError("Bases must be of type integer")

    # Number processing
    (number, is_negative) = _process_number(number)

    # Value validations
    if not validate_number(number):
        raise ValueError(f"\"{number}\" is not a valid number\n"
                         "Hint: Numbers should not start with 0")
    if not validate_number_base(number, from_base):
        raise ValueError(f"The number {number} can't be base {from_base}")
    if not 2 <= to_base <= 36:
        raise ValueError("Only bases between 2 and 36 are accepted")

    if from_base == to_base or number == "0":
        return number

    base_10_conversion = _convert_to_base_10(number, from_base) if from_base != 10 \
        else int(number)

    # If the base to convert to is 10, we can return it right away, since the
    # number was already converted to base 10
    if to_base == 10:
        return f"-{base_10_conversion}" if is_negative \
            else str(base_10_conversion)

    conversion = _convert_number_base_loop(base_10_conversion, to_base)
    return conversion if not is_negative \
        else f"-{conversion}"


def _convert_to_base_10(number: str, from_base: int) -> int:
    base_10_conversion: int = 0
    number_position: int = 0
    for digit in number[::-1]:
        isolated_digit_value = convert_string_numeric_value(digit)
        base_10_conversion += isolated_digit_value * from_base ** number_position
        number_position += 1

    return base_10_conversion


def _convert_number_base_loop(division_quotient: int, to_base: int) -> str:
    division_remainders: str = ""
    while division_quotient != 0:
        division_remainder = division_quotient % to_base
        division_remainders += convert_number_to_single_digit_string(
            division_remainder)
        division_quotient = division_quotient // to_base

    conversion = division_remainders[::-1]

    return conversion
