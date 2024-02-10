import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class Consts {
  static const appTitle = 'תכנית הדר';
  static const defaultLocale = Locale('he', 'IL');

  // storage
  static const accessTokenKey = 'accessTokenKey';
  static const userPhoneKey = 'userPhoneKey';
  static const firstOnboardingKey = 'firstOnboarding';

  // START APIS
  static const baseUrl =
      'https://mis11ka38j.execute-api.us-east-1.amazonaws.com/';

  // onboarding
  static const getAllCities = 'onboarding_form/get_CitiesDB';

  // messages
  static const getAllMessages = 'messegaes_form/getAll';
  static const setMessagesWasRead = 'messegaes_form/setWasRead';
  static const addMessage = 'messegaes_form/add';
  static const deleteMessage = 'messegaes_form/delete';

  // homepage
  static const homePageInitMaster = '/homepage_form/initMaster';

  // master
  static const deleteApprentice = 'master_user/deleteEnt';

  // notifications
  static const getAllNotifications = 'notification_form/getAll';

  // tasks
  static const getAllTasks = 'tasks_form/getTasks';

  // reports
  static const getAllReports = 'reports_form/getAll';

  // madadim charts
  static const chartsMelave = 'madadim/melave';
  static const chartsEshkol = 'madadim/eshcolCoordinator';
  static const chartsMosad = 'madadim/mosadCoordinator';

  // user profile / apprentices
  static const getAllApprentices = 'userProfile_form/myApprentices';

  // END APIS

  // durations
  static const defaultDurationM = Duration(milliseconds: 300);
  static const defaultDurationL = Duration(milliseconds: 600);
  static const defaultDurationXL = Duration(milliseconds: 900);
  static const defaultErrorDuration = Duration(milliseconds: 4000);

  // widget props
  static const borderRadius24 = BorderRadius.all(Radius.circular(24));
  static const defaultBoxShadow = BoxShadow(
    color: Color(0x0d000000),
    offset: Offset(0, 12),
    blurRadius: 24,
  );
  static const defaultBoxDecorationWithShadow = BoxDecoration(
    color: Colors.white,
    boxShadow: [
      defaultBoxShadow,
    ],
    borderRadius: borderRadius24,
  );

  // geolocation
  static const defaultCameraPosition = CameraPosition(
    target: LatLng(
      defaultGeolocationLat,
      defaultGeolocationLng,
    ),
  );
  static const defaultGeolocationZoom = 12.0;
  static const defaultGeolocationLat = 32.06834658255528;
  static const defaultGeolocationLng = 34.78350443313145;

  // mocks
  static const mockApprenticeGuids = [
    '464acc72-1b70-4045-aed1-5f9e4b9d4be2',
    'd2a17853-e5a1-4258-b139-d28dc53fff09',
    'a7af07a8-a1ef-4f2c-ab4f-1d3b48519844',
    '4855401c-824a-4512-a68f-678d01c47fef',
    '5aedb081-8cae-4bb5-98a9-a1ee87a07cb9',
    '84444fc8-fcba-405a-b442-e67895774467',
    '94a094d3-3b42-4166-a743-308f32d5ecdc',
    '3406d633-0a7b-45d1-970c-4b58a70fbd62',
    'cbc2536e-7295-40c6-9f1a-67a62c2b8470',
    '0ce3e72a-a90f-40aa-bcf9-7021f2244915',
    '38eb007b-c039-49c0-a501-8b59b7eddf5a',
    'b5813aee-ec2c-42ff-bc71-38637ebdbe85',
    '48e87897-d9f0-4df7-902d-6991447dff5d',
    '6bf93164-b5e8-4fac-aebd-d34135ab9873',
    'ab3b4696-6136-4f33-b3b7-e960043c7384',
    '932c7313-6e36-4877-8a63-5d1f1e8e45ef',
    'fe63b252-7cd2-44b2-b522-e39ff9bd961c',
    '5b1f7b2d-8b3b-4b1f-9b28-bfbfb8533330',
    '5485721f-b540-4607-9344-18ee5e783a89',
    'f47e3bea-eee9-409b-9bf5-079f9a054375',
    '705325f5-e40e-42ed-9a2f-c3534bb9f8b7',
    '0ce4aa5d-a2fe-4c09-8c83-2d6154c226bb',
    '24db619c-0a16-4ad0-bd2c-d98087118901',
    'bcea0952-b79f-4fa5-a885-b91630c2d86e',
    '75daec34-8170-4483-95bc-20ab47b38bdb',
    '403c92eb-0130-4c4e-a26e-c6e7ae48b45c',
    '0a042901-03dd-4b56-95a6-6639b27af6fc',
    '022f5145-a476-42eb-8d3b-8472bbb58884',
    '9358bf11-f3a8-4ed4-8f9d-49e1ec2cbb41',
    '1a79e5ac-8e5a-43f5-8a98-62d9bff6618e',
    'dd2350c2-f28e-4136-884d-aa1b8e29f066',
    '30442701-dd5d-4e51-91b2-8882fe93fa0c',
    'ebb5dcbd-529c-40c2-8a92-7531f6be0f15',
    '02ee3ee0-c57a-4681-a80d-93a0ffe81d34',
    'bfaf7186-22d9-4825-81a6-b93041a45050',
    '3a33fbb7-60a8-46af-888f-db049364cb3e',
    '57abad12-0ec2-40f8-b016-417519fc02a1',
    '6c82db25-596b-4f3e-95c4-02a5af2d4b0e',
    '384afc16-ba14-4a9c-b0c0-1bde6b819dd0',
    'e2631ef4-397c-45ac-8925-a15b9db99beb',
    '6c6633ad-db80-498b-864a-606d2d4ae104',
    'ed589b91-88ed-4134-8207-f92d34add297',
    '0623fd56-7049-489b-8cd5-2de2e6ace6b4',
    '3cdb7e23-ec9a-4142-a162-dbc8790a482f',
    'f86c356e-5f22-46fc-b68a-b503552c0c12',
    'd9f87726-a965-49d9-b4a3-eb9831f5ed0c',
    '2f131b5c-8bb6-4bb1-a35e-15da28b26eb2',
    'f0582dcf-3ffc-4991-98fc-c10907156373',
    '8837c852-a62d-4b6b-b925-332f870f5ce7',
    'cf691897-e989-424a-ba2b-6e9a0087e5c1',
    'd4541552-45ff-4a0e-bcec-242ccfd06792',
    'c6e3dd7a-1d16-44f6-9911-0ead38aa3acc',
    '023e001b-8cf1-4c9d-8b84-2364245cf827',
    '0f8ee858-ee81-4ba3-bcaf-de6ae4f53f10',
    'fe430a07-0dcc-4d45-b711-c146415387b5',
    'bd207d20-4a53-4b6a-9793-53de3aff68a5',
    '31172572-1176-4eb2-b1ab-b60730e56b29',
    '0966638f-a0bd-40ab-b307-c8ba59f9807b',
    '449e76f7-02f2-43c4-9627-24c64fe0c0cd',
    '396ded5c-9e23-40c5-97ad-fa8e16e96f1f',
    '5ac95203-3c31-44e1-9ad2-310205ffb940',
    'b054d258-8e13-40c0-bb82-428f8f55230c',
    'da1127c3-8f3c-415b-aeaf-2fa6b52e9633',
    'c8ecf08f-dac1-40e5-9da1-4378968901d7',
    'fe5f84fc-76ea-442a-8781-4e2cc4aee94e',
    'eebd7dd0-b868-452a-947f-bd1308c88df3',
    '970dedd5-5d30-4ebb-a56e-f43f16832915',
    'b11afbfa-ad9f-4a4d-91e9-a331201d8628',
    'a6458f8c-fe72-4d00-abfe-707be6ca1e16',
    'b2dc3e70-2d8c-402c-a547-114ce3f0df50',
    'ec0ec3c1-7f8d-4f34-b6c4-c9411dddd4b6',
    '51f987d3-511e-429e-bf87-da0783783cf5',
    'ddf36a2d-018e-46c1-8943-d4052f0e1e6a',
    'df22e340-74ce-4679-aa29-bdd0165e3828',
    'e521bac5-ffce-48bb-a181-a1e78fa56968',
    'a4308c52-a070-498e-82f7-3de9c843b830',
    '952760d4-94c0-4683-b4c7-be1590e358a9',
    'ae0331c2-0c3f-4d41-88ff-4b731a008b7a',
    '67e6f7ca-f9c4-4a89-a960-bc54b53a38ee',
    'cd186e34-f1b7-4675-9822-2552b5b83e0c',
    'b5c601ed-172b-4557-9bbc-7ede46bcd501',
    '5fe79d73-5786-493e-904d-9d4cf09c2d72',
    '05960eb3-0c7e-4422-8c88-1217e982b951',
    '266e4beb-39ee-480c-9809-1c1258bc6182',
    '85908f8f-0fe6-44cf-b0e6-cc64c3de952d',
    'fc67bf3e-1e19-4bee-913d-5aec7761b9a1',
    'e86d6f94-9d2e-49f4-b395-00c6848539c1',
    '83157911-4a93-45d9-ad74-068332191e26',
    '38bab515-aebe-440f-913d-83625c9e5718',
    '819696a5-9f81-4a18-b066-9a4fdb463787',
    '5eb69837-654b-49c3-b029-ebb177cfe19a',
    'b1a63703-ea01-4caa-8d73-30738e1cc3a7',
    '8a8d1975-d555-41a9-a260-05fa8e082600',
    '8c719fd6-d2b9-48d9-9ccf-1b6146eef5eb',
    'ed6f271c-5bef-4229-af8c-55b2f2f2db13',
    'b1fe84fa-f63b-4a76-a423-3e4894459317',
    '08a557d4-6c01-43b7-add0-9943cf3c6835',
    'f1bfbc7c-4c05-4950-8258-91ceddb4643b',
    'dfb76767-4aff-4fee-ae8c-44012ce5160f',
    '0f7ca6e7-2b30-4a44-9cd7-333ef78dcf33',
    '337c0e75-4475-482d-9a92-fed6d6a8af87',
    '78ef4b17-4c28-4e65-9691-840f025d37d8',
    '2d4e4b39-2e15-495c-8e0e-28d59f02fb3e',
    'b8d76dda-0cf2-457e-89b4-eec98ec73cce',
    '959fecd6-4d08-42d3-b806-d31c54648bbd',
    '2f205a9b-659f-4f73-9ecb-2fabd5a52df0',
    '1ba967b0-e496-45a3-9f4e-c48f7d576d81',
    'e0baefcb-be11-41aa-a907-e2e5e9b44404',
    'b2011f04-e284-413d-8f45-e6c001b3222a',
    'cb9cc6d3-a0cc-4560-88d4-a3f7ad678f60',
  ];

  static const mockCompoundGuids = [
    '8583aaf6-3210-4b30-9f41-b017857534ee',
    '8c1f83f9-af44-4742-b3eb-21ee143e6d3d',
    'c6553bee-f264-498d-accb-62a1f3d230e4',
    'b71c9ee2-386e-4fed-8c10-ed1174f0d9b7',
    '082a7e04-8969-487c-87be-93768e6971c8',
    '8c593e03-6554-444d-9986-3bcb55d18d76',
    'b1580a5e-8d5c-42a5-bf15-19bc42fa70ac',
  ];

  static const mockInstitutionsGuids = [
    '893c246f-6660-4b48-b601-333427db1ec4',
    'fb1f61ab-6249-4f18-82e7-1329ec0e057a',
    '73d77bdc-0e69-472a-9aa0-de9372bd8d17',
    'cbf2d591-d26f-4689-8e03-90ab9801cc80',
    'b694bcf6-63c1-47f8-94ad-1a011863396b',
    'dc2b89ba-a97d-42b0-ac49-27a0960b4a0f',
    '69e07ae5-4914-4c97-8359-237d97cf49ad',
    '4e85ecfa-e77f-49c5-8cbf-1cc584b6b0dd',
    '1aebc453-3152-47ac-862f-8e4b561c1e42',
    'b277f2c0-3075-4510-ab29-a839c5719e21',
    'b5602bbd-f2b5-459b-b191-96b4df75f92c',
    'c3eeacd4-51e6-4169-a2a2-353cf429286d',
    'bf8504aa-f571-4f0c-b8a2-817455284237',
    '76bc736c-f03d-4886-bb0a-d3702d1b4752',
    '9d5d6272-4c61-446c-92f2-9722491a3452',
    '05afda99-be15-4acb-83bf-257789274640',
    '01fe7a19-f966-41cb-9632-16488c9098fa',
    '316bb102-ada8-4aa2-838c-f1d5d0b6e25c',
    '2b122dd6-14b0-411c-b282-b50e63a0ab00',
    '79d6bc04-66b7-41ff-b955-2650ce57a7e3',
  ];

  static const mockEventsGuids = [
    'a670ef66-eb63-4238-a2c3-d5bab95c7d1d',
    'cf7e034c-a82a-461e-8a85-279a06714a20',
    '2e83f37c-3b85-4cf0-8cc3-fbce1074bc79',
    '5a8e5aaf-7bc5-4167-aa28-e786c47703a8',
    '83209b35-9bac-4c72-86aa-e5ee4a28f5e9',
    '5dce518c-1f8d-4de8-a0b3-b6649960f8af',
    '64477800-2f30-4fb8-bad2-412e5d5835c0',
    '5e57c505-4eff-4d22-b900-596ce41bd8bf',
    'd4cb4d18-7cc9-4c93-8cb1-4b68809eb55f',
    '491dbedd-bece-471d-951e-40627fa39df8',
    'f046cfad-ba73-4258-ae74-f3d9815ff31e',
    '3a9adb55-5efa-4795-adc1-b55824f7dc63',
    'c9ac0d3f-2f04-4ac1-845a-c749c12d6efa',
    'e6af991b-8348-4967-ad19-1732bd3f6ebc',
    '20a9884a-84e6-4051-b24b-3ba87e067e07',
  ];

  static const mockTasksGuids = [
    'e9fd74ec-d2a2-4a63-8f50-c7b1c1f5983f',
    '0057efc9-359c-4ee5-8ff9-27826025b734',
    '58fa2004-8bf5-4b76-8a18-10d8f890976a',
    '3d2b4d52-2c47-4b84-ac40-18a4cc10238f',
    '566c8ffa-e8da-4724-ae16-460f31411236',
    'b5073a96-7e92-454e-b006-b42e6a0e647b',
    'd12cf3cb-1170-48c8-ba2d-fad6eb62c366',
    'c4809706-0e9f-4a80-8477-830de5c12eb5',
    'a2b9d787-4d2a-4490-8452-974f55d76d60',
    '269b7d22-b697-44e9-8b06-58e5c1b5f9c7',
    'dc24389a-d64c-4618-9fc0-f6eb85fc69d3',
    'a8ef4ffc-07e7-4f49-9be3-ea32f757f99b',
    '1eee94e9-d945-4891-ac2b-d5bdfd851eb0',
    '34aeacf2-564e-4e06-a782-0c7a00ef0084',
    'f31f0bab-5027-4fba-bb10-f3ca8b6ebbdd',
    'b5f4b95e-3f8c-48b5-bd17-da3dbca8c54e',
    '78cce7bb-5593-45eb-ab59-b649f10889bb',
    '2237dd63-67cd-425d-b010-8610dea8e4d3',
    '4ddb70bd-81dd-4fec-b3f3-9b706e15c7ab',
    '2833bf84-7fd4-4dcf-98ab-fda18bccda51',
  ];

  static const termsOfService = '''
תנאי שימוש באפליקציה "תוכנית הדר״
1. כללי 
1.1. ברוכים הבאים לאפליקציה "תוכנית הדר" (להלן: "האפליקציה"). 
1.2. האפליקציה הינה בבעלות הדר יוזמות חינוכיות (להלן: "הבעלים") וכל שימוש בה על ידך כפוף להוראות תנאי השימוש להלן. 
1.3. בהעדר הסכמה לאילו מהתנאים הכלולים בתנאי שימוש אלו,  עליך להימנע מלעשות כל שימוש באפליקציה. 
1.4. בבחירתך לעשות שימוש כלשהו באפליקציה הנך להסכים לתנאי  שימוש אלו במלואם. 
1.5. הבעלים שומרים לעצמם את הזכות לשנות תנאי שימוש אלו, והנך להסכים בזאת כי בכל שימוש שלך באפליקציה לאחר  המועד שבו תנאים אלו השתנו עליך לקבל על עצמך את הגרסה  המעודכנת. 
1.6. אם הנך מתחת לגיל 18, אינך מורשה להשתמש באפליקציה זו  או לבצע כל פעילות בה ללא הסכמת הוריך. על ידי לחיצה על "אני מסכים" , אתה מאשר שהם קראו ומסכימים להוראות תנאי  שימוש אלה. 
1.7. האפליקציה נועדה לשימושך, בכפוף לתנאי שימוש אלו. 
1.8. תנאי שימוש אלו חלים על האפליקציה ו/או חלקים ממנה ועל  השימוש בה ובתכנים הכלולים בה, לרבות על עיצובים, קוד מקור,  מודולי תוכנה ותכנים ו/או מוצרים ו/או שירותים כלשהם של  האפליקציה ו/או שהאפליקציה מאפשרת נגישות ו/או הורדה שלהם,  והם מהווים חלק בלתי נפרד מהם ומתפקוד האפליקציה ו/או  משירותים המוצעים בה ו/או באמצעותה, בתמורה או שלא בתמורה  (להלן, ביחד ולחוד: "השירותים"). 
1.9. הסדרת רישיונות כלשהם לצורך שימוש באפליקציה (כגון רישיון  נהיגה, רישיון עסק, רישיון לעסוק בתיווך וכו'), כמו גם ביטוח  מכל סוג, תשלומי מיסים והוצאות והסדרה של עניינים אחרים  הנובעים מהוראות החוק לצורך ביצוע פעילות עסקית או אחרת  באמצעות אפליקציה זו, הנם באחריותך בלבד. 
1.10. השימוש במידע, במוצרים ו/או בשירותים כלשהם באמצעות  האפליקציה ובכלל הינם באחריותך הבלעדית ובכפוף להוראות  תנאי שימוש אלו.
1.11. הנך להסכים בזאת במפורש כי הבעלים פטורים לחלוטין מכל  אחריות, נזק או אי נוחות, לך או לאחרים, לגבי כל היבט של  שימוש באפליקציה/במוצרים/בשירותים באמצעות האפליקציה או  שיסופקו לך באמצעותה והנך לקחת את כל האחריות לכך על  עצמך בלבד ולבצע את כל הבדיקות הדרושות. 
 
2. תנאי השימוש 
2.1. תנאי שימוש אלו נועדו להבהיר מה הם התנאים החלים על כל מי  שעשה, עושה ו/או יעשה שימוש באפליקציה. 
2.2. בתנאי שימוש אלו, הביטוי "תוכן" כולל כל שירות, מוצר, קוד מקור,  מודול תוכנה, יישום תוכנה, טקסט, תצלום, תמונה, עיצוב, איור, מפה, קטע צליל, קטע וידיאו, גרפיקה, ביטוי, יצירה, ידע או מידע  אחר, בשלמותם ו/או בחלקם, המוצגים באפליקציה זו ו/או שימשו  לתכנונה/אפיונה ו/או המוזנים אליה ו/או הכלולים בה ו/או הממוענים  אליה/ממנה, וזאת בכל אמצעי תקשורת ו/או קשר, בין בתשלום ובין  בלא תשלום, על ידך ו/או צד שלישי כלשהו, וכן כל זכות קניין רוחני,  לרבות, אך לא רק, פטנטים, סימני מסחר זכויות יוצרים וזכויות  מוסרית, המתייחסות לאלו מהם. 
2.3. כל שימוש שייעשה בתנאי שימוש אלו בלשון זכר או בלשון נקבה  הינו לצרכי נוחות בלבד, והפנייה היא לנשים ולגברים כאחד. כמו-כן,  כל פניה ליחיד משמעה גם פנייה לרבים ולהפך. 
2.4. הוראות תנאי שימוש אלו הן מצטברות ו/או חלופיות ו/או משלימות,  לפי העניין והקשר הדברים. 
 
3. הגישה לאפליקציה 
3.1. הבעלים שומרים לעצמם את הזכות לאפשר או לא לאפשר שימוש  באפליקציה בכל עת, וכן לשנות ו/או להפסיק לעשות כן, והכל לפי  שיקול דעתם הבלעדי. 
3.2. יכול שהגישה לאפליקציה או חלקה, והאפשרות לבצע פעולות  מסוימות, תתאפשר למשתמשים מסוימים אך תהא מוגבלת  למשתמשים אחרים, מסיבות כאלה ואחרות, או לא תתאפשר כלל  ו/או תהא כרוכה בהקצאת שם משתמש ו/או סיסמה ו/או תהא  מותנית במילוי שאלון ו/או מסירת פרטים אישיים, הכל לפי שיקול  דעתם המוחלט והבלעדי של הבעלים. 
3.3. הבעלים יוכלו להתחיל לדרוש זאת ללא הודעה מוקדמת, או להוסיף  לדרוש זאת, או להפסיק לדרוש זאת, או לעשות כן מדי פעם בפעם,  ללא הודעה מוקדמת, ולפי שיקול דעתם המוחלט והבלעדי. 
 
4. שימוש במידע שמסרת
4.1. אם מסרת כתובת דואל (email), הנך מסכים בזאת לקבל הודעות  לכתובת דואל אותה מסרת לצרכים שונים, ובכלל זה פרסומות,  הזמנות, הצעות הודעות ומסרים מסחריים מכל סוג. הנך רשאי  לבקש להפסיק שיגור של הודעות כאמור בהתאם להוראות כל דין. 
4.2. ע"י השימוש באפליקציה הנך להסכים בזאת לאיסוף והתחקות אחר  נתונים, מידע, תוכן,אנשי קשר, תמונות ווטאפ, מיקום עצמי, פעולות והרגלי שימוש שלך ואלו ישמשו לצרכים  שונים, לרבות מסחריים ושיווקיים.
 
5. סוגי התכנים באפליקציה 
5.1. הבעלים שומרים לעצמם את הזכות לבחור האם ואלו תכנים יופיעו  ו/או יפורסמו, או יפסיקו/יוסיפו להופיע ו/או להתפרסם באפליקציה,  או יופיעו/יתפרסמו מדי פעם בפעם, הכל לפי שיקול דעתם הבלעדי  והמוחלט, ולפי צרכיהם המסחריים, וללא הודעה מראש או עדכון  בדיעבד. 
5.2. הבעלים עשויים לשנות, להוסיף, לגרוע, למחוק ולעדכן מעת לעת  את תכני האפליקציה ו/או מראה האפליקציה ו/או אופן הפעלתה ו/או  אופן השימוש בה ו/או מוצרים ו/או שירותים הכלולים בה, ללא  הודעה מוקדמת ולפי שיקול דעתם הבלעדי. 
5.3. הבעלים שומרים לעצמם את הזכות לכלול באפליקציה תכנים  המהווים פרסומות שלהם ו/או של אחרים ו/או תכנים מסחריים  אחרים כלשהם (להלן: "פרסומות"). 
5.4. תמונות, אילוסטרציות והדמיות המופיעות באפליקציה הינן  להמחשה בלבד, ואינן מחייבות את הבעלים. 
5.5. הפרסומות שיופיעו באפליקציה ו/או שיישלחו למשתמשים בה, הינן  באחריות המלאה והבלעדית של המפרסמים. 
5.6. בתכני האפליקציה עלולות ליפול שגיאות לרבות במועדים, מחירים,  תנאי תשלום ועוד, והבעלים שומרים על זכותם לתקן כל טעות  כאמור בכל עת. 
 
6. חיפוש תכנים באפליקציה
6.1. הבעלים שומרים לעצמם את הזכות להפעיל דרכי גישה, אמצעי חיפוש ו/או  מנועי חיפוש באפליקציה, שיאפשרו גישה לתכנים מסוימים באפליקציה או  חלק ממנה עפ"י בחירת הבעלים, וכן לשנות ו/או להפסיק לעשות כן, והכל  לפי שיקול דעתם הבלעדי.
 
7. זמינות תכנים באפליקציה 
הנך לאשר כי יתכנו תקלות כאלה ואחרות, הנובעות מסיבות כאלה ואחרות,  העלולות למנוע את הגישה ו/או השימוש באפליקציה, או להכביד עליהם,  לרבות עקב קשיי תקשורת ו/או לשם תחזוקה ו/או מטעמים אחרים, ויכול 
שהשימוש באפליקציה ייקטע ו/או יופסק ללא השלמה ו/או שמירה. הבעלים  יהיו פטורים מכל אחריות לכך, ועליך לשמור מראש כל מידע שבדעתך לעשות  בו שימוש או להזין לאפליקציה, בטרם עשותךכן. 
8. תפקוד מכשירים 
מבלי לגרוע מן האמור לעיל, הנך מאשר כי ידוע לך כי במקרים מסוימים  השימושיות של האפליקציה תלויה בתפקוד תקין של מכשיר הסמארטפון  שברשותך ורכיבים הכלולים בו כי GPS, BlueToothועוד. אשר איכותם, אי דיוקם, שיבוש בהם ותקלות, עלולים להפריע לחווית השימוש שלך באפליקציה. הבעלים יהיו פטורים מכל אחריות לכך. 
 
9. תשלומים אשר יכול שיבוצעו דרך האפליקציה 
9.1. מחירים באפליקציה, ככל שיהיו כאלה, נכונים למועד הצגתם,  ועשויים להתעדכן ולהשתנות מעת לעת לפי שיקול דעת הבעלים ו/או  לפי שיקול דעת המפרסמים. 
 
10. הזנת תכנים לאפליקציה 
10.1. אם במסגרת שימוש באפליקציה, חיפוש, הזמנת מוצרים ו/או  שירותים ו/או פעילות אחרת באמצעות האפליקציה, האפליקציה  תאפשר לך להזין מידע ו/או תכנים כלשהם, האחריות על תכנים אלו,  משמעותם ועצם הזנתם תחול עליך בלבד. 
10.2. מבלי לגרוע מהאמור לעיל, אין להזין לאפליקציה ו/או להפיץ ממנה  ו/או באמצעותה תוכן כלשהו שעלול לפגוע באדם כלשהו, שמו הטוב,  פרטיותו, קנייניו או זכויותיו, ואין להזין תכנים לאפליקציה בניגוד  להוראות תנאי שימוש אלו ו/או הוראות כל דין. 
10.3. הבעלים שומרים לעצמם את הזכות, לערוך, לשנות ואף למחוק  תכנים כאלו. הנך לתת בזאת את הסכמתך המפורשת לעריכת  שינויי תוכן ו/או עריכה ו/או מחיקה של תכנים כלשהם שהוזנה לאפליקציה. 
10.4. זו זכותך לפנות לבעלים ולבקש מחיקה של תכנים שהזנת  לאפליקציה והבעלים ישתדלו למלא אחר בקשתך, אולם הם אינם  מתחייבים לעשות כן. 
10.5. האחריות לכל מעשה או מחדל שאינם עולים בקנה אחד עם  האמור לעיל הינה עליך בלבד. 
 
11. קישורים, פרסומות והפניות מהאפליקציה 
11.1. באפליקציה יכול שתהיה הפניה לתכנים, פרסומות ומקורות שאינם בשליטה  ו/או פיקוח של הבעלים. לפיכך אם יופיע בהם חומר פוגעני, בלתי מוסרי,  בלתי חוקי, או אם ייגרם באמצעותם ו/או בגינם נזק מכל זוג, אזי לבעלים ו/או  מי מטעמם אין ולא תהא כל אחריות על כך.
 
12. זכויות בעלות וזכויות קניין רוחני 
12.1. זכויות הקניין הרוחני מוגנות בישראל ובחו"ל מכוח חוקי מדינת  ישראל ואמנות בינלאומיות. 
12.2. הבעלים מכבדים זכויות בעלות וזכויות קניין רוחני של אחרים, וגם  עליך לעשות כן. 
12.3. אפליקציה זו ותכניה הם הרכוש הבלעדי של בעלי זכויות הקניין  בהם, ואינם רכושך, ואין לעשות בהם כל שימוש אלא בכפוף לתנאי  שימוש אלו. 
12.4. אלא אם הוסכם במפורש אחרת מראש ובכתב, יש לראות את  המידע ו/או זכויות הקניין הרוחני באפליקציה כשל הבעלים בלבד  ו/או כמותרים לשימוש הבעלים ע"י צדדים שלישיים, ובכלל זה זכויות  יוצרים, זכויות מוסריות, סימני מסחר, סימני שרות, שמות מסחריים,  מדגמים, פטנטים, יצירות, עיצובים, המצאות, סודות מסחריים,  מידע טכנולוגי, מידע פונקציונאלי, מידע מקצועי, מידע מסחרי  ועסקי, וכל מידע ו/או זכות קניין רוחני, בין שנרשמה, ובין שלא  נרשמה (להלן: "זכויות הקניין הרוחני"). 
12.5. צדדים שלישיים בעלי זכויות קניין רוחני בתכנים שהוזנו לאפליקציה  ללא ידיעת הבעלים של ו/או הסכמתם, מתבקשים לפנות לבעלים  ו/או למי מטעמם ולדווח להם על כך. 
12.6. הבעלים שומרים לעצמם את הזכות לאכוף, להסיר, לשנות, לתקן,  ולמנוע כל שימוש ו/או הזנה לאפליקציה ו/או פרסום של תכנים  המפרים זכויות קניין רוחני שלהם ו/או של צדדים שלישיים, ולדרוש  כל פיצוי ו/או שיפוי מכל מי שעלול להעמיד את עצמו ו/או את  הבעלים במצב של הפרה אפשרית של זכויותיהם ו/או של אחרים. 
 
13. שימוש בתכני האפליקציה 
13.1. אין לעשות באפליקציה ו/או בתכניה כל שימוש פוגעני באדם כלשהו,  שמו הטוב, פרטיותו, או זכויותיו, ואין לעשות שימוש כלשהו  באפליקציה ו/או בתכניה שהינו בניגוד לתנאי שימוש אלו ו/או הוראות  כל דין, נוהג, או תקנת הציבור. 
13.2. כל שימוש באפליקציה ו/או בתכנים כלשהם הכלולים בה ו/או נלקחו  ממנה, הינם לשימוש אישי בלבד, ואין לעשות כל שימוש אחר לרבות  עסקי, שיווקי או מסחרי, אלא אם יותר לעשות כן ע"י הבעלים  במפורש, מראש ובהיתר בכתב, ובהתאם לתנאי ההיתר, כאמור  בגוף האפליקציה. 
13.3. בכלל זה, ומבלי לגרוע מכלליות האמור לעיל, אין לנצל איזו מזכויות  הקניין הרוחני של הבעלים ו/או צד שלישי ללא הסכמתם, לרבות, אך 
13.4. לא רק, בדרך של גזירה, העתקה, שמירה כקובץ, שכפול, הפצה,  עיבוד, מחיקה, תוספת, שינוי, מכירה, השכרה, השאלה, מסירה,  הצגה פומבית, ביצוע פומבי, יצירת יצירה ניגזרת, או כל דרך  אחרת. העושה כן ללא היתר מפורש מאת הבעלים, מראש ובכתב, ככל  שיינתן ובכפוף לתנאיו, מסתכן בהעמדה לדין פלילי ובהליכים  אזרחיים, לרבות צווי מניעה, חיפוש, תפיסה, תביעות כספיות, עיכוב  טובין, מעצר, מאסר, וכל אמצעי אכיפה אחר ו/או נוסף שהבעלים  ימצאו לנכון. 
13.5. אין ולא יהיה בהיתר שיינתן לך ע"י הבעלים לעשות שימוש בתכנים  כלשהם באפליקציה, אם וככל שיינתן, כדי לגרוע מזכויות הבעלים,  לרבות זכויות בעלות בכלל, וזכויות הקניין הרוחני בפרט, ולא ישתמע  ממעשה או מחדל כלשהו של הבעלים משום הסכמה להעברה ו/או  למתן שימוש בזכות קניין רוחני כלשהי או זכות אחרת לבעל ההיתר  או לאדם אחר, אלא אם הוסכם על כך במפורש, מראש ובכתב,  ובכפוף לזכויות השייכות לבעלים, או שהאחרונים קיבלו מצדדים  שלישיים, ובכפוף להוראות כל דין.
13.6. מבלי לגרוע מהאמור לעיל, "שימוש הוגן" ביצירה, כמשמעותו בכל  דין הינו מותר למטרת לימוד עצמי, מחקר, ביקורת, סקירה, דיווח  עיתונאי, הבאת מובאות, הוראה ובחינה על ידי מוסד חינוך, בכפוף  לכל דין בישראל בלבד. בכל שימוש הוגן, חובה לתת קרדיט למחבר  התוכן ולאפליקציה. אין להטיל בתוכן כל פגם, או לעשות בו כל סילוף  או שינוי צורה אחר, או פעולה פוגענית אחרת, אם יש באילו מהם  כדי לפגוע בכבודו או בשמו של היוצר
. 
14. פטור מאחריות 
14.1. האפליקציה והתכנים הכלולים בה, מוצגים ומוצעים לשימוש במצבם  כפי שהוא ("Is As"). 
14.2. הבעלים לא יישאו באחריות כלשהי, חוזית ו/או נזיקית ו/או אחרת,  לשימוש כלשהו שייעשה באפליקציה ו/או בישומייה, ו/או למניעה ו/או  להפרעה משימוש באפליקציה מסיבה כלשהי. 
14.3. הבעלים לא יישאו באחריות כלשהי לתכנים שיימסרו או יוזנו על  ידך, חוקיותם, אמינותם, מהימנותם, דיוקם, שלמותם, קבצי מחשב  שיצורפו אליהם, ולכל נזק, הפסד, עגמת נפש או תוצאות, במישרין  או בעקיפין, לך ו/או לצד שלישי כלשהו. 
14.4. הבעלים לא יישאו בכל אחריות לכל נזק עקב הורדת האפליקציה  ו/או נזק שנבע מקישור הכלול באפליקציה ולכל נזק שנבע מהצגה או  מפרסום של תכנים כאמור בכל דרך אחרת. כמו כן, אחריות המלאה  והבלעדית לכל קישור, הצגה או פרסום של התכנים שנעשו על ידך הנם עליך והנך להתחייב בזאת לשפות את הבעלים בגין כל נזק  שייגרם כתוצאה מכך. 
14.5. הבעלים לא מתחייבים לשמור תכנים כלשהם שהזנת לאפליקציה,  ו/או שהורדת מהאפליקציה, והאחריות על שמירת תכנים באמצעים  שלך, הינם בלתי תלויים בבעלים ו/או באפליקציה ו/או במי הקשור  עימם, והיא עליך בלבד. שמירת תכנים כאלו הינה בכפוף להוראות  כל דין ותנאי שימוש אלו.
14.6. הנך להצהיר בזאת כי כל אחריות וסיכון לכל נזק ו/או הפסד שייגרמו  לך בגין השימוש באפליקציה הינם עליך, לרבות: תאונות, עוגמת  נפש, היבטים כלכליים וכל נזק אחר. כן יצויין כי השימוש במכשיר  הנייד בזמן נסיעה הינו אסור ומסוכן לך ולסביבתך. 
 
15. שיפוי 
15.1. הנך להתחייב לשפות ולפצות את הבעלים ו/או כל מי מטעמם, בגין כל מעשה  ו/או מחדל שגרם לבעלים נזק ישיר או עקיף, הפסד, אבדן-רווח, תשלום או  הוצאה, בין עקב הפרת תנאי שימוש אלו, בין עקב הפרת הוראות כל דין, ובין  עקב כל טענה או תביעה מצד שלישי כלשהו.
 
16. סמכות שיפוט 
16.1. דיני מדינת ישראל בלבד יחולו על הוראות תנאי שימוש אלו ופרשנותם, ומקום  הבוררות והשיפוט יהיו בבית המשפט המוסמך במחוז תל אביב או מחוז מרכז בלבד.
 
17. שינויים בתנאי שימוש 
17.1. יכול שבהוראות תנאי שימוש אלו יחולו מעת לעת שינויים, עדכונים, תוספות,  מחיקות, לפי שיקול דעתם המוחלט והבלעדי של הבעלים, עליהם תפורסם  הודעה. אם הינך מעוניין להמשיך לעשות שימוש באפליקציה זו, ייראו אותך  כמסכים לתנאים המתוקנים, אלא אם הם יעמדו בסתירה להוראות החוק. 
 
18. פנה אלינו 
נשתדל לטפל בפניות מתאימות אלינו בהקדם האפשרי. פניות כאמור יש  להעביר לפי הפרטים להלן: 
שם: לירן גרובס
טלפון: 0506795170 
 tochnithadar@gmail.com :EMAIL

 
 
 
מדיניות פרטיות לאפליקציה 
1. כללי 
1.1. מדיניות פרטיות זו היא חלק בלתי נפרד מתנאי השימוש לאפליקציה "תוכנית הדר" (להלן:  "האפליקציה") בבעלות הדר יוזמות חינוכיות (להלן: "הבעלים") וכל שימוש בה  על ידך כפוף להוראות תנאי השימוש להלן. 
1.2. מטרת מדיניות הפרטיות היא לפרט בפניך, המשתמש/ת, כיצד נאספים עליך נתונים  באמצעות האפליקציה, מה מטרת השימוש וכיצד נעשה בהם שימוש, אם בכלל. 
1.3. הוראות מסמך זה יפורשו בהתאם לדיני מדינת ישראל בלבד. בכל מקרה של  סכסוך, מקומו של הליך כלשהו יהיה בבית המשפט המוסמך במחוז תל-אביב או  מחוז המרכז בלבד, והמותב הרלבנטי ידון בו עפ"י דיני מדינת ישראל בלבד. 
1.4. הוראות מדיניות הפרטיות יחולו על האפליקציה יחד עם שינויים, עדכונים, תוספות,  או מחיקות, כפי שיבוצעו מדי פעם בפעם על פי שיקול דעתו המוחלט והבלעדי של  הבעלים, בהודעה שתפורסם (להלן: "השינויים"). המשך שימוש באפליקציה לאחר  שינויים אלו יחשב כהסכמה לתנאים המתוקנים, אלא אם כן הם סותרים הוראות  קוגנטיות (בלתי ניתנות להתניה) של הדין הישראלי. 
 
2. מדיניות הפרטיות שלנו 
2.1. אנו שומרים לעצמנו את הזכות לאפשר גישה לאפליקציה על ידי תהליך רישום או  על ידי אמצעי רישום שמעמידים צדדים שלישיים כגון פייסבוק ועוד. 
2.2. בתהליך הרשמה, תשלום, או תהליך הזנה אחר באפליקציה, ייתכן שיהיה עליך  להזין פרטים כמו שמך, כתובת הדואר האלקטרוני, כתובת דואר, פרטי כרטיס  אשראי או פרטים אחרים לפי העניין, אותם אנו אוספים. 
2.3. אנו עשויים להשתמש במידע שאנו אוספים ממך(אנשי קשר, תמונות ווטאפ, מיקום עצמי, ספר טלפונים, מצלמה, נתוני אפליקציה, כאמור בעת רישום, ביצוע רכישה,  הרשמה לניוזלטר שלנו, בעת עריכת סקר שיווק, או באחד או יותר מהמקרים  הבאים: 
2.3.1. כדי להתאים אישית את חווית המשתמש שלך וכדי לאפשר לנו לספק לך את  השירות או המוצר שבו יש לך עניין, או כדי לעבד את העסקאות שלך במהירות האפשרית. 
2.3.2. האפליקציה נבדקת על בסיס קבוע כדי לאתר חורי אבטחה ונקודות תורפה ידועות  על מנת להפוך את השימוש בה עבורך בטוח ככל האפשר.
2.4. אנו מיישמים מגוון של אמצעי אבטחה כאשר משתמשים אחרים עושים שימוש  באפליקציה כדי להבטיח שלא תהיה להם נגישות אלא למידע שלהם ותוך שמירת  המידע האישי שלך מפניהם. 
2.5. עסקות שמבוצעות באמצעות האפליקציה אינן מעובדות באפליקציה עצמה, אלא  אצל גורמים מומחים לכך, והן אינן מאוחסנות על השרתים שלנו אלא על שרת חיצוני מאובטח.
 
3. צדדים שלישיים 
3.1 אנחנו לא מוכרים, סוחרים, או מעבירים לגורמים חיצוניים את פרטיך האישיים,  למעט אלו שהסכמת מראש. 
3.2 אנו עשויים לאפשר פרסומות באפליקציות שלנו. 
3.3 אנו נעשה את המירב כדי לא לאפשר לצדדים שלישיים לבצע מעקב אחריך. 
 
4. פנו אלינו 
נשתדל לטפל בפניות מתאימות אלינו בהקדם האפשרי. פניות כאמור יש  להעביר לפי הפרטים להלן: 
שם: לירן גרובס
טלפון: 0506795170 
 tochnithadar@gmail.com :EMAIL
''';
}
