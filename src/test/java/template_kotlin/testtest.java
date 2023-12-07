package template_kotlin;

import com.omnilab.micrm.common.CommonUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class testtest {

    public static void main(String[] args) {
        Logger logger = LoggerFactory.getLogger("testtest");

        // admin@hankyung.com
        logger.error("{}", CommonUtils.sha512("hankyung_20230926_#@"));
        logger.error("{}", CommonUtils.sha512("daewonmedia_20231123_#@"));
        logger.error("{}", CommonUtils.sha512("milvus_1@3$"));
    }

}
