package template_kotlin;

import org.apache.commons.math3.analysis.function.Exp;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.net.ssl.HttpsURLConnection;
import java.io.BufferedReader;
import java.io.InputStream;
import java.net.URL;
import java.security.*;
import java.security.cert.Certificate;

public class test {

    public static void main(String[] args) throws Exception {
        KeyStore ks = KeyStore.getInstance("Windows-MY");
        ks.load(null, null);

        //PrivateKey privKey = (PrivateKey) ks.getKey(alias, null);
        //Certificate cert = ks.getCertificate(alias);

        Provider p = ks.getProvider();
        Signature sig = Signature.getInstance("SHA1withRSA", p);
        //sig.initSign(privKey);
        byte[] signature = sig.sign();
        System.out.println("\tGenerated signature...");
        //sig.initVerify(cert);
        if (sig.verify(signature)) {
           System.out.println("\tSignature verified!");
        }
    }

    public void conTest(){
        Logger logger = LoggerFactory.getLogger("test");
        String urlString = "https://dip.joongang.co.kr";
        String line = null;
        InputStream in = null;
        BufferedReader reader = null;
        HttpsURLConnection httpsConn = null;
        try {
            // Get HTTPS URL connection
            URL url = new URL(urlString);
            httpsConn = (HttpsURLConnection) url.openConnection();
            httpsConn.setDoInput(true);

            int responseCode = httpsConn.getResponseCode();
            logger.error("응답코드 : " + responseCode);
            logger.error("응답메세지 : " + httpsConn.getResponseMessage());
        }catch (Exception e){
            logger.error("test", e);
        }finally {
            if (httpsConn != null) {
                httpsConn.disconnect();
            }
        }
    }

}
