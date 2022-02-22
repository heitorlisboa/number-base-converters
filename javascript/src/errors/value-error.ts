class ValueError extends Error {
  constructor(message?: string) {
    super(message);

    // Set prototype explicitly
    // https://github.com/Microsoft/TypeScript/wiki/Breaking-Changes#extending-built-ins-like-error-array-and-map-may-no-longer-work
    Object.setPrototypeOf(this, ValueError.prototype);
  }
}

export default ValueError;
