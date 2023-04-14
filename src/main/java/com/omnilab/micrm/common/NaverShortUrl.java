package com.omnilab.micrm.common;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

public class NaverShortUrl {
	
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
            System.out.println(e);
            return null;
        }
	}
}
