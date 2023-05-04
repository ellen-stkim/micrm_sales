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

    /**
     * @param : HttpServletRequest
     * @return : String ip
     * @Method Name  : clientip
     * @author : OMNILAB
     * @Method Description : 클라이언트 아이피 체크
     */
    public static String clientip(HttpServletRequest req) {
        String ip = req.getHeader("X-Forwarded-For");
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = req.getHeader("Proxy-Client-IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = req.getHeader("WL-Proxy-Client-IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = req.getHeader("HTTP_CLIENT_IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = req.getHeader("HTTP_X_FORWARDED_FOR");
        }

        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = req.getHeader("X-CLIENT-IP");
        }

        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
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
     * @param : String
     * @return : boolean
     * @Method Name  : isDigit
     * @Method Description :
     * String 문자열을  Double로 Parse 하여 변환되면 true, 변환되지 않으면 false를 리턴한다.
     */
    public static boolean isDigit(String s) {
        try {
            Double.parseDouble(s);
            return true;
        } catch (NumberFormatException e) {
            return false;
        }
    }

    /**
     * @param : String
     * @return : boolean
     * @Method Name  : isBit
     * @version : 0.1
     * @Method Description :
     * 입력받은 문자열이 0 또는 1인지 체크하여 true 및 false를 리턴한다.
     */
    public static boolean isBit(String s) {
        if (!s.equals("0") && !s.equals("1")) {
            return false;
        }
        return true;
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
     * @param : String value, int start, int end
     * @return : boolean
     * @Method Name  : stringBetween
     * @version : 0.1
     * @Method Description :
     * 입력받은 문자열 str이 int start와 int end 이상 이하인 경우 true를 리턴하며
     * String이 정수가 아니거나 start 보다 미만, end 를 초과할 경우 false를 리턴한다.
     */
    public static boolean stringBetween(String value, int start, int end) {
        try {
            int i = Integer.parseInt(value);
            if (i >= start && i <= end) {
                return true;
            } else return false;
        } catch (Exception e) {
            return false;
        }
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

    public static String EscapeTextToHtml(String t) {
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
     * @param : Map<String, String[]> parameterMap, Class<T> dto
     * @return : <T> T
     * @throws : IllegalAccessException, InstantiationException
     * @Method Name  : getDTOFromParamMap
     * @version : 0.1
     * @Method Description :
     * 입력받은 ParameterMap을 함께 입력받은 Dto 객체로 치환한 다음 DTO 객체를 리턴한다.
     */
    public static <T> T getDTOFromParamMap(Map<String, String[]> parameterMap, Class<T> dto) throws IllegalAccessException, InstantiationException {

        final MutablePropertyValues sourceProps = getPropsFrom(parameterMap);

        T targetDTO = dto.newInstance();
        DataBinder binder = new DataBinder(targetDTO);
        binder.bind(sourceProps);

        return targetDTO;
    }

    /**
     * @param : Map<String, String[]> parameterMap
     * @return : MutablePropertyValues
     * @throws : IllegalAccessException, InstantiationException
     * @Method Name  : getPropsFrom
     * @version : 0.1
     * @Method Description :
     */
    private static MutablePropertyValues getPropsFrom(Map<String, String[]> parameterMap) {

        final MutablePropertyValues mpvs = new MutablePropertyValues();

        parameterMap.forEach(
                (k, v) -> {
                    String dotKey =
                            k.replaceAll("\\[]", "")
                                    .replaceAll("\\[(\\D+)", ".$1")
                                    .replaceAll("]\\[(\\D)", ".$1")
                                    .replaceAll("(\\.\\w+)]", "$1");
                    mpvs.addPropertyValue(dotKey, v);
                }
        );

        return mpvs;
    }

    /**
     * @param : HttpServletRequest request, String name
     * @return : String
     * @throws : UnsupportedEncodingException
     * @Method Name  : getCookie
     * @version : 0.1
     * @Method Description :
     * request에 저장되어있는 Cookie 중에서 name 문자열과 일치하는 쿠키명의 값을 리턴한다. 없는 경우 null을 리턴한다.
     */
    public static String getCookie(HttpServletRequest request, String name) {
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (cookie.getName().equals(name)) {
                    return cookie.getValue();
                }
            }
        }
        return null;
    }

    /**
     * @param : Date
     * @return : String
     * @Method Name : simpleDateToDatetime
     * @Method Description :
     * Date date 객체를 받아서 yyyy-MM-dd HH:mm:ss 형식의 String을 반환한다.
     */
    public static String simpleDateToDatetime(Date date) {
        SimpleDateFormat form = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String strDate = form.format(date);
        return strDate;
    }

    /**
     * @param : Date date
     * @return : String
     * @Method Name : simpleDateToDate
     * @Method Description :
     * Date date 객체를 받아서 기본 날짜형 yyyy-MM-dd 형식 String을 반환한다.
     */
    public static String simpleDateToDate(Date date) {
        SimpleDateFormat form = new SimpleDateFormat("yyyy-MM-dd");
        String strDate = form.format(date);
        return strDate;
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
     * @param : String[] p, int i
     * @return : String
     * @Method Name : blankStringArr
     * @Method Description : 공백 리턴 배열용
     */
    public static String blankStringArr(String[] p, int i) {
        if (CommonUtils.isEmptyObject(p)) {
            return "";
        } else if (p.length <= i) {
            return "";
        } else {
            return p[i];
        }
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
     * @param : MultipartFile
     * @return : boolean
     * @Method Name : checkExcelMime
     * @Method Description : 파일 엑셀 확인.
     */
    public static String checkEecelMime(MultipartFile file) {
        String fileMime = file.getContentType();
        if (fileMime.equals("application/vnd.ms-excel")
                || fileMime.equals("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
                || fileMime.equals("text/css")) {
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
            //return s.replaceAll("(\r\n|\r|\n|\n\r|\\\\r\\\\n|\\\\r|\\\\n|\\\\n\\\\r)", "<br>");
            return s.replaceAll("(\r\n|\r|\n|\n\r|\\\\r\\\\n)", "<br>");
            //return s.replaceAll("(\r\n|\r|\n|\n\r)", "<br>");
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
        int radix = 1 << shift;
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

}