const fs = require('fs')

const source = './anki-10.txt'
const data = fs.readFileSync(source, 'utf-8')

const arr = data.split('----\n')

let newFile = '';
const size = arr.length;

arr.filter((v, i) => v).forEach((str, i) => {
    const regexp = /([\p{sc=Kana}\p{sc=Hira}ー⓪①②③④⑤⑥⑦⑧⑨➓]+)/u;
    // 添加## 
    str = str.replace(regexp, `## $1`);

    // アジア Asia 添加 <rt></rt>
    const regexp2 = /([\p{sc=Kana}ー]+)(\s)?([a-zA-Z ]+)/u;
    str = str.replace(regexp2, `$1<rt>$3</rt>`)

    const brr = str.split('\n');
    // 只有例句的单词 什么也不做 直接copy
    if (brr.length <= 11) {
        newFile += str;
    } else {
        let tempArr = [];
        for (let i = 0; i < 9; i++) {
            tempArr.push(brr[i]);
        }
        // 　近义词 反义词 惯用词 关联词等处理， （解析不处理）
        for (let i = 9; i < brr.length; i++) {
            let tempStr = brr[i];
            const regexp = /^\s+<font>/;
            // font标签包裹， 不是解析， 且有2个或以上的词语才需要处理
            if (regexp.test(tempStr) && tempStr.indexOf('、') >= 0 && tempStr[9] != '析') {
                // console.log(`before -> index:${i}, value:${tempStr}`);
                // 首先去除原来的 <ruby></ruby>, 再去除无用的 <rt></rt>
                tempStr = tempStr.replace(/<\/?ruby>/g, '')
                    .replace(/(、)<rt><\/rt>/g, '$1')
                // 分为两部分， 前面不变， 后面分组添加<ruby></ruby> 再拼接为字符串
                let preffix = tempStr.substring(0, 18)
                tempStr = tempStr.substring(18);

                const handlerStr = preffix + tempStr.split('、').map(t => t.replace(/(.*)/, '<ruby>$1</ruby>')).join('、');

                // console.log(`preffix: ${preffix}.`);
                // console.log(` after -> index:${i}, value:${tempStr}`);
                // console.log(`handler-> value:${handlerStr}`);

                tempArr.push(handlerStr);
            } else {
                tempArr.push(brr[i]);
            }
        }

        newFile += tempArr.join('\n');

        // console.log('tempArr', tempArr);
    }

    if (i != size - 1) {
        newFile += '- - -\n'
    }
})

console.log(newFile);

const filePath = './jekyll-10.txt'
if (fs.existsSync(filePath)) fs.unlinkSync(filePath)
fs.writeFileSync(filePath, newFile)
