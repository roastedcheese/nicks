export function cut(str, i = 14) {
  if (str.length <= i)
    return str;
  let cutStr = str.slice(0, i).trim() + '...';
  return cutStr;
};
