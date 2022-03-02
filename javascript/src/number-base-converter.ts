import ValueError from "./errors/value-error";
import { reverseString, integerDivision } from "./utils";
import type { integer } from "./types";

const lowerCaseAlphabet = Array.from(Array(26)).map((_, i) =>
  String.fromCharCode(i + 97)
);

export function validateNumber(number: string): boolean {
  const regex = /^[-]?[a-zA-Z1-9][a-zA-Z0-9]*$/;
  const match = number.match(regex);

  return match ? true : false;
}

export function validateSingleDigitNumber(number: string): boolean {
  const regex = /^[a-z0-9]{1}$/;
  const match = number.match(regex);

  return match ? true : false;
}

export function validateNumberBase(number: string, base: number): boolean {
  if (!(2 <= base && base <= 36)) {
    throw RangeError("Only bases between 2 and 36 are accepted");
  }

  const maxValue = base - 1;

  let valid = true;
  for (let digit of number) {
    const isolatedDigitValue = convertStringNumericValue(digit);
    if (isolatedDigitValue > maxValue) valid = false;
  }

  return valid;
}

export function convertStringNumericValue(character: string): number {
  if (character.length !== 1) {
    throw new ValueError("Insert only 1 character");
  }
  if (!validateSingleDigitNumber(character)) {
    throw new ValueError(`${character} is not a valid number`);
  }

  const isLetter = isNaN(parseInt(character));
  let numericValue: number;

  if (isLetter) {
    const letterIndex = lowerCaseAlphabet.findIndex(
      (value) => value === character
    );
    numericValue = letterIndex + 10;
  } else {
    numericValue = parseInt(character);
  }

  return numericValue;
}

export function convertNumberToSingleDigitString(number: number): string {
  /* Since numbers bigger than 9 will be represented as a letter, and the
  alphabet only has 26 letters, the number needs to be between 10 (which
  represents the letter "a") and 10 + the 25 remaining alphabet characters */
  if (10 <= number && number <= 10 + 25) {
    return lowerCaseAlphabet[number - 10];
  } else if (0 <= number && number <= 9) {
    return number.toString();
  } else {
    throw RangeError("Only numbers between 0 and 35 are accepted");
  }
}

/**
 * Convert an integer (as a string) from any base between 2 and 36 to another
 * base from the same range
 * @param number Number to convert
 * @param fromBase Number base to convert from (default = 2)
 * @param toBase Number base to convert to (default = 10)
 * @returns The converted number
 */
export default function convertNumberBase(
  number: string,
  fromBase: integer = 2,
  toBase: integer = 10
): string {
  // Type validations
  if (typeof number !== "string") {
    throw new TypeError("The number to convert must be of type string");
  }
  if (typeof fromBase !== "number" || typeof toBase !== "number") {
    throw new TypeError("Bases must be of type number");
  }
  if (!Number.isInteger(fromBase) || !Number.isInteger(toBase)) {
    throw new ValueError("Bases must be integers");
  }

  // Processing parameters
  number = number.toLowerCase();
  fromBase = Math.round(fromBase);
  toBase = Math.round(toBase);

  let isNegative: boolean;
  if (number[0] === "-") {
    number = number.slice(1);
    isNegative = true;
  } else {
    isNegative = false;
  }

  // Value validations
  if (!validateNumber(number)) {
    throw new ValueError(
      `"${number}" is not a valid number\n` +
        "Hint: Numbers should not start with 0"
    );
  }
  if (!validateNumberBase(number, fromBase)) {
    throw new ValueError(`The number ${number} can't be base ${fromBase}`);
  }
  if (!(2 <= toBase && toBase <= 36)) {
    throw new RangeError("Only bases between 2 and 36 are accepted");
  }

  if (fromBase === toBase || number === "0") return number;

  let base10Conversion = 0;
  let numberPosition = 0;
  for (let digit of reverseString(number)) {
    const isolatedDigitValue = convertStringNumericValue(digit);
    base10Conversion += isolatedDigitValue * fromBase ** numberPosition;
    numberPosition++;
  }

  if (toBase === 10) {
    return isNegative ? `-${base10Conversion}` : base10Conversion.toString();
  }

  let divisionQuotient = base10Conversion;
  let divisionRemainders = "";
  while (divisionQuotient !== 0) {
    const divisionRemainder = divisionQuotient % toBase;
    divisionRemainders += convertNumberToSingleDigitString(divisionRemainder);
    divisionQuotient = integerDivision(divisionQuotient, toBase);
  }

  const conversion = reverseString(divisionRemainders);

  return isNegative ? `-${conversion}` : conversion;
}
