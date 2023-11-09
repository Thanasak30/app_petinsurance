//IPv4 session
const String ipv4 = "192.168.1.2";// ipv4 ของไวไฟที่ใช้อยู่นะปัจจุบัน

//Header session
const Map<String, String> headers = {"Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json',
      'Accept-Language': 'th',
      'Accept': '*/*'};

//Farmer session
const String baseURL = "http://" + ipv4 + ":8080";