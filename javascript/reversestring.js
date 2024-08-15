export const reverseString = (str) => {
    let newString = '';
    for (let index = str.length -1; index >=0; index--) {
        newString += str(index);
    }
    return newString;
}

