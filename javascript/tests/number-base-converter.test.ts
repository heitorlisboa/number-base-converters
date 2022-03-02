import ValueError from "../src/errors/value-error";
import convertNumberBase from "../src/number-base-converter";

describe("numberBaseConverter function", () => {
  it("should throw ValueError when invalid character is passed", () => {
    function convertInvalidNumber() {
      convertNumberBase("87.5");
    }
    const regex = /not[\w\s]*valid[\w\s]*number/i;

    expect(convertInvalidNumber).toThrow(regex);
    expect(convertInvalidNumber).toThrow(ValueError);
  });

  it("should throw ValueError when first numeric digit is zero", () => {
    function convertZeroAsFirstNumericDigit() {
      convertNumberBase("-0");
    }
    const regex = /not[\w\s]*valid[\w\s]*number/i;

    expect(convertZeroAsFirstNumericDigit).toThrow(regex);
    expect(convertZeroAsFirstNumericDigit).toThrow(ValueError);
  });

  it("should throw ValueError when number doesn't correspond the informed base", () => {
    const base = 10;
    function convertNumberNotCorrespondingBase() {
      convertNumberBase("ff", base);
    }
    const regex = new RegExp(`(can't|isn't|not)[\\w\\s]*base ${base}`, "i");

    expect(convertNumberNotCorrespondingBase).toThrow(regex);
    expect(convertNumberNotCorrespondingBase).toThrow(ValueError);
  });

  it("should throw RangeError when baseFrom is greater than max", () => {
    function convertBaseFromGreaterThanMax() {
      convertNumberBase("f", 37);
    }
    const regex = /2[\w\s]*36/;

    expect(convertBaseFromGreaterThanMax).toThrow(regex);
    expect(convertBaseFromGreaterThanMax).toThrow(RangeError);
  });

  it("should throw RangeError when baseFrom is less than min", () => {
    function convertBaseFromLessThanMin() {
      convertNumberBase("f", 1);
    }
    const regex = /2[\w\s]*36/;

    expect(convertBaseFromLessThanMin).toThrow(regex);
    expect(convertBaseFromLessThanMin).toThrow(RangeError);
  });

  it("should throw RangeError when baseTo is greater than max", () => {
    function convertBaseToGreaterThanMax() {
      convertNumberBase("1", 2, 37);
    }
    const regex = /2[\w\s]*36/;

    expect(convertBaseToGreaterThanMax).toThrow(regex);
    expect(convertBaseToGreaterThanMax).toThrow(RangeError);
  });

  it("should throw RangeError when baseTo is less than min", () => {
    function convertBaseToLessThanMin() {
      convertNumberBase("1", 2, 1);
    }
    const regex = /2[\w\s]*36/;

    expect(convertBaseToLessThanMin).toThrow(regex);
    expect(convertBaseToLessThanMin).toThrow(RangeError);
  });

  it("should return a negative number when baseTo is 10 and the number is negative", () => {
    const convertedNumber = convertNumberBase("-1", 2, 10);
    expect(convertedNumber).toMatch("-1");
  });

  it("should return a negative number when baseTo is 16 and the number is negative", () => {
    const convertedNumber = convertNumberBase("-1", 2, 16);
    expect(convertedNumber).toMatch("-1");
  });

  it("should correctly convert from binary to decimal", () => {
    const number = "1000";
    const expectedConversion = "8";
    const convertedNumber = convertNumberBase(number, 2, 10);
    expect(convertedNumber).toEqual(expectedConversion);
  });

  it("should correctly convert from decimal to binary", () => {
    const number = "18";
    const expectedConversion = "10010";
    const convertedNumber = convertNumberBase(number, 10, 2);
    expect(convertedNumber).toEqual(expectedConversion);
  });

  it("should correctly convert when using uppercase letters", () => {
    const number = "10F";
    const expectedConversion = "271";
    const convertedNumber = convertNumberBase(number, 16);
    expect(convertedNumber).toEqual(expectedConversion);
  });

  it("should convert to rounded base when using base as a float number", () => {
    const number = "15";
    const expectedConversion = "f";
    const convertedNumber = convertNumberBase(number, 10.2, 15.5);
    expect(convertedNumber).toEqual(expectedConversion);
  });
});
