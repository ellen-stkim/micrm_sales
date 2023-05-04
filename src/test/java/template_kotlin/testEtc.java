package template_kotlin;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class testEtc {

    private static Logger logger = LoggerFactory.getLogger("testEtc");

    public static void main(String[] args) {
        logger.error("{}", 0 | 123 | 0 | 4232);
        logger.error("{}", 123 | 0 | 4232);
        logger.error("{}", 123 | 4232);
    }
}
