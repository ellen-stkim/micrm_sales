package template_kotlin;

import com.omnilab.micrm.common.AES256;
import com.omnilab.micrm.common.CommonUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;


public class testReg {
    public static Logger logger = LoggerFactory.getLogger("testReg");

    public static void main(String[] args) {

        /*HttpHeaders headers = new HttpHeaders();
        MultiValueMap<String, String> parameters = new LinkedMultiValueMap<>();
        parameters.add("username", "lucas");
        parameters.add("server", "https://tableau-report.com/");

        RestTemplate rest = new RestTemplate();

        ResponseEntity<String> result = rest.exchange("https://tableau-report.com/trusted", HttpMethod.POST, new HttpEntity(parameters, headers), String.class);

        logger.error("{}", result.getBody());
        logger.error("{}", result.getHeaders());
        logger.error("{}", result.getStatusCode());
        */
        logger.error("{}", AES256.AES_Encode("01033966795/1", "7779328267167869"));
        logger.error("{}", AES256.AES_Encode("1", "7779328267167869"));


    }
}
