import sharp from 'sharp';
const svg = `<svg xmlns="http://www.w3.org/2000/svg" width="1200" height="630"><rect width="1200" height="630" fill="#FBF8F2"/><text x="80" y="300" font-family="Georgia, serif" font-size="84" fill="#1F1D1A">Federico De Cillia</text><text x="80" y="384" font-family="Georgia, serif" font-size="44" fill="#B5482B">I build AI that ships.</text></svg>`;
await sharp(Buffer.from(svg)).png().toFile('public/og.png');
console.log('og.png written');
