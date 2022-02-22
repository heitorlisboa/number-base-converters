from python.src.number_base_converter import convert_number_base
import pytest


class TestNumberBaseConverter:
    def test_When_InvalidNumberCharacter_Expect_ValueError(self):
        with pytest.raises(ValueError, match=r"not[\w\s]*valid[\w\s]*number"):
            convert_number_base("87.5")

    def test_When_FirstNumericDigitIsZero_Expect_ValueError(self):
        with pytest.raises(ValueError, match=r"not[\w\s]*valid[\w\s]*number"):
            convert_number_base("-0")

    def test_When_NumberNotCorrespondingBase_Expect_ValueError(self):
        base = 10
        with pytest.raises(ValueError, match=fr"can't|isn't | not[\w\s]*base {base}"):
            convert_number_base("ff", base)

    def test_When_BaseFromGreaterThanMax_Expect_ValueError(self):
        with pytest.raises(ValueError, match=r"2[\w\s]*36"):
            convert_number_base("f", 37)

    def test_When_BaseFromLessThanMin_Expect_ValueError(self):
        with pytest.raises(ValueError, match=r"2[\w\s]*36"):
            convert_number_base("f", 1)

    def test_When_BaseToGreaterThanMax_Expect_ValueError(self):
        with pytest.raises(ValueError, match=r"2[\w\s]*36"):
            convert_number_base("1", to_base=37)

    def test_When_BaseToLessThanMin_Expect_ValueError(self):
        with pytest.raises(ValueError, match=r"2[\w\s]*36"):
            convert_number_base("1", to_base=1)

    def test_When_NumberIsNegative_Expect_ReturnNegativeNumber(self):
        converted_number = convert_number_base("-1")
        assert converted_number.startswith("-")

    def test_When_BinaryToDecimal_Expect_CorrectConversion(self):
        number = "1000"
        expected_conversion = "8"
        converted_number = convert_number_base(number)
        assert converted_number == expected_conversion

    def test_When_DecimalToBinary_Expect_CorrectConversion(self):
        number = "18"
        expected_conversion = "10010"
        converted_number = convert_number_base(number, 10, 2)
        assert converted_number == expected_conversion