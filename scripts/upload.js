const cloudinary = require("cloudinary");

/*configure our cloudinary*/
cloudinary.config({
  cloud_name: "thebookofeveryone",
  api_key: "API_KEY",
  api_secret: "API_SECRET"
});

cloudinary.v2.uploader.upload(
  "/Users/tboe/Desktop/ww_giftbox_02_v01.png",
  {
    folder: "/images/wise/new_parents/",
    invalidate: true,
    public_id: "ww_giftbox_02_v02"
  },
  function(error, result) {
    console.log(result);
    console.log(error);
  }
);
