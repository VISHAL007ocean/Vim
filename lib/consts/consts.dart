library constants;

// const String BASE_URL = "https://vim-ltd.com"; //TODO for production
// const String BASE_URL = "https://vim-ltd.com"; //TODO for production
// const String BASE_URL = "https://demo.vim-ltd.com"; //TODO for dev
const String BASE_URL = "https://dev.vim-ltd.com"; //TODO for old dev

enum QuestionTypes {
  passFail,
  freeText,
  longText,
  number,
  date,
  datetime,
  image,
  yesNo,
  YesNoUnsure, //dropdown (yes,no,unsure)
  ThirdPartyMySelfUnsure, //dropdown(thirdparty, myself, unsure)
}

enum UserEmotions {
  happy,
  neutral,
  sad,
  angryStressed,
  tired,
  unwell,
}
