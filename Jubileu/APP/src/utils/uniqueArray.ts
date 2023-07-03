export const uniqueArray = (array: any) => {
    return array.reduce((acc: any, current: any) => {
        const x = acc.find((item: { id: any; }) => item.id === current.id);
        return !x ? acc.concat([current]) : acc;
    }, []);
}