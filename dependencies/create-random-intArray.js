module.exports = function (len, maxLimit) {
    // len: length of array to create
    // maxLimit: generate random numbers from 0 to maxLimit
    const zeroIndexed = maxLimit - 1;
    const ints = [];
    while (len > 0) {
        const random = Math.random() * zeroIndexed;
        const integer = Math.floor(random);
        ints.push(integer);
        len = len - 1;
    }
    return ints;
}

