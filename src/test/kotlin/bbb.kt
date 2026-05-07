import com.google.gson.GsonBuilder
import com.google.gson.reflect.TypeToken
import com.omnilab.micrm.model.table.kakao.WideItemDto
import org.apache.poi.ss.usermodel.*
import org.apache.poi.xssf.usermodel.XSSFWorkbook
import org.apache.poi.ss.util.CellRangeAddress
import org.apache.poi.xssf.streaming.SXSSFWorkbook
import org.slf4j.LoggerFactory
import java.io.FileOutputStream
import kotlin.math.log

class bbb {
}

fun main() {
    val logger = LoggerFactory.getLogger("bbb")

    val st = "[{\"title\":\"내용\",\"img_url\":\"https://mud-kage.kakao.com/dn/rVizg/dJMb9955R5n/acVcHo79h2Kno6yptUtMp1/img_l.jpg\",\"url_mobile\":\"https://www.naver.com\",\"url_pc\":\"https://www.naver.com\"},{\"title\":\"내용2\",\"img_url\":\"https://mud-kage.kakao.com/dn/in1ou/dJMcaaKHrw1/VZztD0kXv2OM2caaKzkEG0/img_l.jpg\",\"url_mobile\":\"https://www.naver.com\",\"url_pc\":\"https://www.naver.com\"},{\"title\":\"내용3\",\"img_url\":\"https://mud-kage.kakao.com/dn/DPiUj/dJMcagqMygb/dAJ5fMvZV8Tr0SrdkUboq0/img_l.jpg\",\"url_mobile\":\"https://www.naver.com\",\"url_pc\":\"https://www.naver.com\"},{\"title\":\"내용4\",\"img_url\":\"https://mud-kage.kakao.com/dn/in1ou/dJMcaaKHrw1/VZztD0kXv2OM2caaKzkEG0/img_l.jpg\",\"url_mobile\":\"https://www.naver.com\",\"url_pc\":\"https://www.naver.com\"}]"
    
    val gson = GsonBuilder().create()
    
    val lst = gson.fromJson<MutableList<WideItemDto>>(st, object : TypeToken<MutableList<WideItemDto>>() {}.type)
   
    for(i in lst){
        logger.error("{}", i)
    }
    
}