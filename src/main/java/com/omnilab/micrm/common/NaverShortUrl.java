package com.omnilab.micrm.common;

import com.omnilab.micrm.config.error.CouponException;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

public class NaverShortUrl {

    public static final Logger log = LoggerFactory.getLogger(NaverShortUrl.class);

    public static JSONObject shorten(String uuid) {
        String clientId = "rfsedehh6a";//애플리케이션 클라이언트 아이디값";
        String clientSecret = "Wgz9vBfeS8FzVY7WR00mcz02yhW0tDoXDzKnAGW3";//애플리케이션 클라이언트 시크릿값";
        
        try {
            String text = uuid;
            String apiURL = "https://naveropenapi.apigw.ntruss.com/util/v1/shorturl";
            URL url = new URL(apiURL);
            HttpURLConnection con = (HttpURLConnection)url.openConnection();
            con.setRequestMethod("POST");
            con.setRequestProperty("Content-Type", "application/json");
            con.setRequestProperty("X-NCP-APIGW-API-KEY-ID", clientId);
            con.setRequestProperty("X-NCP-APIGW-API-KEY", clientSecret);
            con.setDoOutput(true);
            // post request
            JSONObject json = new JSONObject();
            json.put("url", text);
            String postParams = json.toString();
            DataOutputStream wr = new DataOutputStream(con.getOutputStream());
            wr.writeBytes(postParams);
            wr.flush();
            wr.close();
            int responseCode = con.getResponseCode();
            BufferedReader br;
            if(responseCode==200) { // 정상 호출
                br = new BufferedReader(new InputStreamReader(con.getInputStream()));
            } else {  // 에러 발생
                br = new BufferedReader(new InputStreamReader(con.getErrorStream()));
            }
            String inputLine;
            StringBuffer response = new StringBuffer();
            while ((inputLine = br.readLine()) != null) {
                response.append(inputLine);
            }
            br.close();
            
            JSONParser parser = new JSONParser();
            JSONObject obj = (JSONObject) parser.parse(response.toString());
                        
            return obj;
        } catch (Exception e) {
            log.error("NaverShortUrl={}", "네이버 단축 URL 오류");
            throw new CouponException(HttpStatus.INTERNAL_SERVER_ERROR, "서버에 문제가 생겼습니다. 관리자에게 문의 바랍니다.");
        }
    }
}
