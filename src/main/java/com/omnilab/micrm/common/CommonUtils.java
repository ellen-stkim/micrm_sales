package com.omnilab.micrm.common;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.Array;
import java.lang.reflect.Field;
import java.net.URLEncoder;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.regex.Pattern;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import org.apache.commons.codec.binary.Base64;
import org.apache.http.entity.ContentType;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.DateUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.MutablePropertyValues;
import org.springframework.validation.DataBinder;
import org.springframework.web.multipart.MultipartFile;

import static org.springframework.integration.graph.LinkNode.Type.input;


/**
 * @author : OMNILAB
 * @version : 1.0.0
 * @FileName : CommonUtils.java
 * @Project : TEMPLATE
 * @Description :
 * 공통 적으로 사용되는 함수 및 웹 프로젝트 사용시 자주 사용되는 함수 모음
 * @since : 2018. 12. 1.
 */

@SuppressWarnings("rawtypes")
public class CommonUtils {

    public static final Logger log = LoggerFactory.getLogger(CommonUtils.class);

    private static final Pattern SIMPLE_PATTERN = Pattern.compile("^#\\{[^}]+}$");
    private static final Pattern HTTPS_PATTERN = Pattern.compile("^https://#\\{[^}]+}$");
    private static final Pattern HTTP_PATTERN = Pattern.compile("^http://#\\{[^}]+}$");


    /**
     * @param : HttpServletRequest
     * @return : String ip
     * @Method Name  : clientip
     * @author : OMNILAB
     * @Method Description : 클라이언트 아이피 체크
     */
    public static String clientip(HttpServletRequest req) {
        String ip = req.getHeader("X-Forwarded-For");
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = req.getHeader("Proxy-Client-IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = req.getHeader("WL-Proxy-Client-IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = req.getHeader("HTTP_CLIENT_IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = req.getHeader("HTTP_X_FORWARDED_FOR");
        }

        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = req.getHeader("X-CLIENT-IP");
        }

        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = req.getRemoteAddr();
        }

        if(ip.contains(",")){
            return ip.split(",")[0].trim();
        }else{
            return ip;
        }
    }

    /**
     * @param : Object
     * @return : boolean
     * @Method Name  : isEmptyObject
     * @excetion :
     * @serial :
     * @version : 0.1
     * @Method Description :
     * Object를 입력받으면 Object의 instance를 체크한 후 해당 객체가 NULL 또는 공백인지 체크한후
     * 빈 값인 경우 true
     * 비지 않은 경우 false 를 리턴한다.
     * @see :
     */
    public static boolean isEmptyObject(Object obj) {
        if (obj == null) {
            return true;
        } else {
            if (obj instanceof String) {
                return obj.equals("");
            } else if (obj instanceof List) {
                return ((List) obj).isEmpty();
            } else if (obj instanceof Map) {
                return ((Map) obj).isEmpty();
            } else if (obj instanceof Object[]) {
                return Array.getLength(obj) == 0;
            } else {
                return false;
            }
        }
    }

    /**
     * @param : String str
     * @return : String
     * @throws : ParseException
     * @Method Name : stringDateHourParse
     * @Method Description :
     * yyyy-MM-dd 형식의 String을 받아서 Date 객체로 파싱한다.
     * 파싱에 실패한 경우에는 현재 시간을 반환한다.
     */
    public static String stringDateHourParse(String str) {
        SimpleDateFormat form = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Date date;
        try {
            if(str.isEmpty()){
                date = new Date();
            }else{
                date = form.parse(str);
            }
        } catch (ParseException e) {
            log.error("stringDateHourParse {}", str);
            date = new Date();
        }
        return form.format(date);
    }

    public static String stringValueOf(Object object) {
        return object == null ? "" : String.valueOf(object);
    }

    /**
     * @param : String, int
     * @return : boolean
     * @Method Name  : checkByteLength
     * @version : 0.1
     * @Method Description :
     * 입력받은 문자열 str이 byte로 변환 했을 때 limitByte를 초과하는지 검증한 후
     * limitByte 이하 인경우 true, 초과인 경우 false 를 리턴한다.
     */
    public static boolean checkByteLength(String str, int limitByte) {
        int en = 0;
        int ko = 0;
        int etc = 0;

        char[] string = str.toCharArray();
        for (char c : string) {
            if (c >= 'A' && c <= 'z') {
                en++;
            } else if (c >= '\u3131' && c <= '\uD787') {
                ko += 2;
            } else {
                etc++;
            }
        }
        int sum = en + ko + etc;
        return (sum <= limitByte);
    }

    public static int byteLength(String str) {
        int en = 0;
        int ko = 0;
        int etc = 0;

        char[] string = str.toCharArray();
        for (char c : string) {
            if (c >= 'A' && c <= 'z') {
                en++;
            } else if (c >= '\u3131' && c <= '\uD787') {
                ko += 2;
            } else {
                etc++;
            }
        }
        return en + ko + etc;
    }

    /**
     * @param : String startDate, String endDate
     * @return : boolean
     * @Method Name  : compareDate
     * @version : 0.1
     * @Method Description :
     * 문자열  startDate와 endDate를 날짜형식으로 검토후 endDate가 startDate가 더 늦은 날짜면 true,
     * 그 외의 경우에는 false를 리턴한다.
     */
    public static boolean compareDate(String startDate, String endDate) {
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        try {
            Date day1 = dateFormat.parse(startDate);
            Date day2 = dateFormat.parse(endDate);

            int compare = day1.compareTo(day2);
            return compare < 0;
        } catch (ParseException e) {
            log.error("compareDate", e);
            return false;
        }
    }

    /**
     * @param : String
     * @return : String
     * @Method Name  : sha512
     * @excetion : NoSuchAlgorithmException
     * @version : 0.1
     * @Method Description : Sha512 암호화
     */
    public static String sha512(String message) {
        MessageDigest md;
        StringBuilder mes1 = new StringBuilder();
        try {
            md = MessageDigest.getInstance("SHA-512");

            md.update(message.getBytes());
            byte[] mb = md.digest();
            for (int i = 0; i < mb.length; i++) {
                byte temp = mb[i];
                StringBuilder s = new StringBuilder(Integer.toHexString(temp));
                while (s.length() < 2) {
                    s.insert(0, "0");
                }
                s = new StringBuilder(s.substring(s.length() - 2));
                mes1.append(s);
            }
        } catch (NoSuchAlgorithmException e) {
            log.error("|-------------- Sha512 Error : CommonUtils.java ------------------|", e);
        }
        return mes1.toString();
    }

    /**
     * @return : String
     * @Method Name  : getRandString16
     * @version : 0.1
     * @Method Description :
     * 16자리  숫자 + 알파벳 대소문자로 구성된 랜덤 스트링을 리턴한다.
     */
    public static String getRandString16() {
        StringBuilder temp = new StringBuilder();
        SecureRandom rnd = new SecureRandom();
        for (int i = 0; i < 16; i++) {
            int rIndex = rnd.nextInt(2);
            switch (rIndex) {
                case 0:
                    temp.append((char) ((int) (rnd.nextInt(26)) + 97));
                    break;
                case 1:
                    // 0-9
                    temp.append((rnd.nextInt(10)));
                    break;
            }
        }
        return temp.toString();
    }

    /**
     * @return : String
     * @Method Name  : getTimestampMS
     * @version : 0.1
     * @Method Description :
     * 시간의 밀리세컨드를 문자열로 리턴한다.
     */
    public static String getTimestamp() {
        Date now = new Date();
        return String.valueOf(now.getTime());
    }

    public static String escapeTextToHtml(String t) {
        if (t != null) {
            t = t.replaceAll("&gt;", ">")
                    .replaceAll("&lt;", "<")
                    .replaceAll("&quot;", "\"")
                    .replaceAll("&nbsp;", " ")
                    .replaceAll("&amp;", "&")
                    .replaceAll("&apos;", "'")
                    .replaceAll("&lsquo;","‘")
                    .replaceAll("&rsquo;","’")
                    .replaceAll("&ldquo;","“")
                    .replaceAll("&rdquo;","”")
                    .replaceAll("&deg;","°")
                    .replaceAll("&middot;","·")
                    .replaceAll("&times;","×")
                    .replaceAll("&divide;","÷")
                    .replaceAll("&minus;","-")
                    .replaceAll("&infin;","∞")
                    .replaceAll("&sim;","∼")
                    .replaceAll("&ne;","≠")
                    .replaceAll("&le;","≤")
                    .replaceAll("&ge;","≥")
                    .replaceAll("&hellip;","…")
                    .replaceAll("&prime;","′")
                    .replaceAll("&trade;","™")
                    .replaceAll("&rarr;","→")
                    .replaceAll("&larr;","←")
                    .replaceAll("&#39;","'")
                    .replaceAll("&#40;","(")
                    .replaceAll("&#41;",")")
                    .replaceAll("&#42;","*")
                    .replaceAll("&#43;","+")
                    .replaceAll("&#44;",",")
                    .replaceAll("&#45;","-")
                    .replaceAll("&#46;",".")
                    .replaceAll("&#47;","/")
                    .replaceAll("&#58;",":")
                    .replaceAll("&#59;",";")
                    .replaceAll("&#60;","<")
                    .replaceAll("&#61;","=")
                    .replaceAll("&#62;",">")
                    .replaceAll("&#63;","?")
                    .replaceAll("&#64;","@")
                    .replaceAll("&#91;","[")
                    .replaceAll("&#92;","\"")
                    .replaceAll("&#93;","]")
                    .replaceAll("&#94;","^")
                    .replaceAll("&#95;","_")
                    .replaceAll("&#96;","`")
                    .replaceAll("&#123;","{")
                    .replaceAll("&#124;","|")
                    .replaceAll("&#125;","}")
                    .replaceAll("&#126;","~")

            ;
        }
        return t;
    }

    /**
     * @param : String
     * @return : String
     * @throws : ParseException
     * @Method Name : stringDatetimeParse
     * @version : 0.1
     * @Method Description :
     * yyyy-MM-dd HH:mm:ss 형식의 String을 받아서 Date 객체로 파싱한다.
     * 파싱에 실패한 경우에는 현재 시간을 반환한다.
     */
    public static String stringDatetimeParse(String str) {
        SimpleDateFormat form = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Date date;
        try {
            date = form.parse(str);
        } catch (ParseException e) {
            log.error("stringDatetimeParse [{}]", str);
            date = new Date();
        }
        return form.format(date);
    }

    /**
     * @param : String
     * @return : String
     * @throws : ParseException
     * @Method Name : stringDatetimeParse
     * @version : 0.1
     * @Method Description :
     * yyyy-MM-dd HH:mm:ss 형식의 String을 받아서 Date 객체로 파싱한다.
     * 파싱에 실패한 경우에는 현재 시간을 반환한다.
     */
    public static Map stringDatetimeMap(String str) {
        Map<String, String> map = new HashMap<>();
        SimpleDateFormat form = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Date date;
        try {
            date = form.parse(str);
        } catch (ParseException e) {
            log.error("stringDatetimeMap", e);
            date = new Date();
        }

        Calendar c = Calendar.getInstance();
        c.setTime(date);
        map.put("year", String.valueOf(c.get(Calendar.YEAR)));
        map.put("month", String.valueOf(c.get(Calendar.MONTH)));
        map.put("day", String.valueOf(c.get(Calendar.DATE)));
        map.put("h", String.valueOf(c.get(Calendar.HOUR_OF_DAY)));
        map.put("m", String.valueOf(c.get(Calendar.MINUTE)));
        map.put("s", String.valueOf(c.get(Calendar.SECOND)));
        return map;
    }

    /**
     * @param : String str
     * @return : String
     * @throws : ParseException
     * @Method Name : StringDateParse
     * @Method Description :
     * yyyy-MM-dd 형식의 String을 받아서 Date 객체로 파싱한다.
     * 파싱에 실패한 경우에는 현재 시간을 반환한다.
     */
    public static String stringDateParse(String str) {
        SimpleDateFormat form = new SimpleDateFormat("yyyy-MM-dd");
        Date date;
        try {
            date = form.parse(str);
        } catch (ParseException e) {
            log.error("stringDateParse", e);
            date = new Date();
        }
        return form.format(date);
    }

    /**
     * @param : MultipartFile
     * @return : boolean
     * @Method Name : checkImageMime
     * @Method Description : 파일 이미지 확인.
     */
    public static String checkImageMime(MultipartFile file) {
        String fileMime = file.getContentType();
        if (ContentType.IMAGE_JPEG.getMimeType().equalsIgnoreCase(fileMime)
                || ContentType.IMAGE_GIF.getMimeType().equalsIgnoreCase(fileMime)
                || ContentType.IMAGE_PNG.getMimeType().equalsIgnoreCase(fileMime)
                || ContentType.IMAGE_BMP.getMimeType().equalsIgnoreCase(fileMime)) {
            return fileMime;
        } else {
            return null;
        }
    }

    /**
     * _NONE(- 1),
     * NUMERIC(0),
     * STRING(1),
     * FORMULA(2),
     * BLANK(3),
     * BOOLEAN(4),
     * ERROR(5);
     */
    public static String Excel_cell_value(Cell cell) {
        try {
            if (cell == null) {
                return null;
            } else {
                switch (cell.getCellType()) {
                    case NUMERIC:
                        if (DateUtil.isCellDateFormatted(cell)) {
                            SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
                            return formatter.format(cell.getDateCellValue());
                        } else {
                            double d = cell.getNumericCellValue();
                            if (d == Math.floor(d) && !Double.isInfinite(d)) {
                                return String.valueOf((long) cell.getNumericCellValue());
                            } else {
                                return String.valueOf(cell.getNumericCellValue());
                            }
                        }
                    case STRING:
                        return cell.getStringCellValue();
                    case FORMULA:
                        return cell.getStringCellValue();
                    case BLANK:
                        return "";
                    case BOOLEAN:
                        return String.valueOf(cell.getBooleanCellValue());
                    case ERROR:
                        return String.valueOf(cell.getErrorCellValue());
                    default:
                        return null;
                }
            }
        }catch (Exception e){
            log.error("Excel_cell_value : " + cell.getRowIndex(), e);
            throw e;
        }
    }

    /**
     * @param : void
     * @return : String
     * @Method Name : getDateNow
     * @Since : 2017. 07. 11.
     * @author : Steve
     * @excetion :
     * @serial :
     * @version : 0.1
     * @Method Decription : 현재 날짜 및 시간
     * @see :
     */
    public static String getDateTimeNow() {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        return sdf.format(new Date());
    }

    /**
     * @param :
     * @return :
     * @Method Name : numberToPhone
     * @Since :
     * @author :
     * @excetion :
     * @serial :
     * @version : 0.1
     * @Method Decription : 전화번호 하이픈 concat
     * @see :
     */
    public static String numberToPhone(String num) {

        String formatNum = "";
        num = num.replaceAll("-", "");

        if (num.length() == 11) {
            formatNum = num.replaceAll("(\\d{3})(\\d{3,4})(\\d{4})", "$1-$2-$3");
        } else if (num.length() == 8) {
            formatNum = num.replaceAll("(\\d{4})(\\d{4})", "$1-$2");
        } else {
            if (num.indexOf("02") == 0) {
                formatNum = num.replaceAll("(\\d{2})(\\d{3,4})(\\d{4})", "$1-$2-$3");
            } else {
                formatNum = num.replaceAll("(\\d{3})(\\d{3,4})(\\d{4})", "$1-$2-$3");
            }
        }
        return formatNum;
    }

    public static String getDateTimeNowYYYMMDDSSS() {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmssSSS");
        return sdf.format(new Date());
    }

    public static String replaceBr(String s){
        if(s == null){
            return null;
        }else {
            return s.replaceAll("(\r\n|\r|\n|\n\r|\\\\r\\\\n)", "<br>");
        }
    }

    /**
     * @param : String
     * @return : String
     * @throws : ParseException
     * @Method Name : stringDateTimeKorParse
     * @version : 0.1
     * @Method Description :
     * yyyy-MM-dd HH:mm:ss 형식의 String을 받아서 Date 객체로 년 월 일 시 한글로 파싱한다.
     * 파싱에 실패한 경우에는 현재 시간을 반환한다.
     */
    public static String stringDateTimeKorParse(String str) {
        SimpleDateFormat form = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        SimpleDateFormat form2 = new SimpleDateFormat("yyyy년 MM월 dd일 a hh시 ");
        Date date;
        try {
            date = form.parse(str);
        } catch (ParseException e) {
            log.error("stringDatetimeParse [{}]", str);
            date = new Date();
        }
        return form2.format(date);
    }


    public static String textAreaParsing(String s) {
        if(s == null) {
            return null;
        } else{
            return s.replaceAll("(<br/>)","&#10");
        }
    }

    public static String objectToString(Object o){
        return String.valueOf(o);
    }

    /**
     * 고유번호 생성
     *
     * @param i
     * @param shift
     * @return
     */
    public static String toUnsignedString(long i, int shift) {
        char[] buf = new char[64];
        int charPos = 64;
        long radix = 1L << shift;
        long mask = radix - 1;
        long number = i;
        do {
            buf[--charPos] = digits[(int) (number & mask)];
            number >>>= shift;
        } while (number != 0);
        return new String(buf, charPos, (64 - charPos));
    }

    final static char[] digits = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f', 'g',
            'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', 'A', 'B',
            'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W',
            'X', 'Y', 'Z', '_', '*' // '.', '-'
    };

    public static boolean isValid(String input) {
        // 한글, 영어, 숫자만 허용하는 정규 표현식
        String regex = "^[a-zA-Z0-9가-힣]*$"; // 영어 (a-zA-Z), 숫자 (0-9), 한글 (가-힣)
        // 정규 표현식을 패턴에 맞게 검사
        return Pattern.matches(regex, input);
    }

    // 정규식 패턴 정의
    public static boolean matchesPattern(String input) {
        if (input == null) return false;
        return SIMPLE_PATTERN.matcher(input).matches()
            || HTTPS_PATTERN.matcher(input).matches()
            || HTTP_PATTERN.matcher(input).matches();
    }
}