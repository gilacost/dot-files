const csv = require("csv");
const fs = require("fs");
const moment = require("moment");

const parser = csv.parse(function(err, data) {
  if (err) {
    console.error(err);
    return;
  }
  data.reverse().forEach(row => {
    const date = moment(`${row.shift()}-01-01`);
    let fromDateString = date.format("YYYY-MM-DD");
    for (let i = 0; i < row.length; i++) {
      date.add(1, "weeks");
      const toDate = date.clone().subtract(1, "seconds");
      const toDateString = toDate.format("YYYY-MM-DD");
      const cell = row[i].trim();
      if (cell.length <= 0) {
        console.warn(`error empty cell at ${fromDateString}/${i}`);
        continue;
      }
      [song, author] = cell.split("-");
      if (!song || song.length <= 0) {
        console.warn(`error empty song at ${fromDateString}/${i}`);
        continue;
      }
      if (!author || author.length <= 0) {
        console.warn(`error empty author at ${fromDateString}/${i}`);
        continue;
      }
      song = song.replace(/"/g, '\\"');
      author = author.replace(/"/g, '\\"');
      if (!song || !author) {
        console.warn(
          `error parsing song/author for "${cell}" at ${fromDateString}/${i}`
        );
        continue;
      }
      song = song.trim();
      author = author.trim();
      console.log(
        `%{from_date: ~D[${fromDateString}], to_date: ~D[${toDateString}], song: "${song}", artist: "${author}"},`
      );
      fromDateString = date.format("YYYY-MM-DD");
    }
  });
});

fs.createReadStream("./music.csv").pipe(parser);
