package com.omnilab.micrm.service

import com.omnilab.micrm.common.fmsware.GifDecoder
import com.omnilab.micrm.model.table.Tblmi_comm_cdDto
import com.omnilab.micrm.repository.SysSettingDao
import org.apache.commons.io.FilenameUtils
import org.apache.http.HttpEntity
import org.apache.http.client.HttpClient
import org.apache.http.client.methods.HttpGet
import org.apache.http.entity.ContentType
import org.apache.http.impl.client.HttpClients
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Service
import java.awt.Color
import java.awt.Graphics2D
import java.awt.image.BufferedImage
import java.io.*
import java.net.URL
import java.text.SimpleDateFormat
import java.util.*
import java.util.regex.Pattern
import javax.imageio.ImageIO
import javax.swing.text.MutableAttributeSet
import javax.swing.text.html.HTML
import javax.swing.text.html.HTMLEditorKit.ParserCallback
import javax.swing.text.html.parser.ParserDelegator
import kotlin.collections.HashMap
import kotlin.collections.HashSet
import kotlin.collections.set

@Service
class ImgParsing {

    @Autowired
    lateinit var sysSettingDao : SysSettingDao;

    val logger = LoggerFactory.getLogger(this::class.java)
    //에디터 본문에 url 중복 제거 set
    companion object{
        private var slist : MutableSet<String> = hashSetOf()
        //에디터의 이미지가 임시폴더에 저장된 내용 list
        private var rlist : MutableList<String> = arrayListOf()
        //에디터 본문의 내용을 통째로 가져옴.
    }

    class CallbackHandler : ParserCallback() {
        override fun handleStartTag(tag: HTML.Tag, a: MutableAttributeSet, pos: Int) {
            if (tag === HTML.Tag.IMG) {
                if (a.getAttribute(HTML.Attribute.SRC) != null) {
                    if (a.getAttribute(HTML.Attribute.SRC).toString().matches("(?i).*(http|https)://.*")) {
                        slist.add(a.getAttribute(HTML.Attribute.SRC).toString())
                    }
                }
            }
        }

        override fun handleSimpleTag(tag: HTML.Tag, a: MutableAttributeSet, pos: Int) {
            if (tag === HTML.Tag.IMG) {
                if (a.getAttribute(HTML.Attribute.SRC) != null) {
                    if (a.getAttribute(HTML.Attribute.SRC).toString().matches("(?i).*(http|https)://.*")) {
                        slist.add(a.getAttribute(HTML.Attribute.SRC).toString())
                    }
                }
            }
        }
    }

    fun parse(str: String, path: String): Map<String, Any>? {
        var str2 = str
        slist = HashSet()
        rlist = ArrayList<String>()
        val map: MutableMap<String, Any> = HashMap()
        try {
            val reader = InputStreamReader(ByteArrayInputStream(str2.toByteArray(charset("UTF-8"))))
            val p = ParserDelegator()
            p.parse(reader, CallbackHandler(), true)
            reader.close()
            str2 = imgFile(str2, path, slist)
            map["temp"] = str2
            map["list"] = rlist
        } catch (e: Exception) {
            logger.error("File parse: $e")
            map["temp"] = "false"
        }
        return map
    }
    fun imgFile(str: String, localPath: String, hlist: Set<String?>): String {
        var str2 = str
        val inDate = SimpleDateFormat("yyyyMMddHHmmss.SSS").format(Date())
        var stream: InputStream? = null
        var i = 0
        val USER_AGENT = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/56.0.2924.87 Safari/537.36"
        for (url in hlist) {
            val file_ext = url?.let { file_ext(it) }
            try {
                val client: HttpClient = HttpClients.createDefault()
                val httpGet = HttpGet(url)
                httpGet.addHeader("User-Agent", USER_AGENT)
                val response = client.execute(httpGet)
                val entity: HttpEntity = response.entity
                stream = entity.content

                val contentType = ContentType.getOrDefault(entity)
                val mimeType = contentType.mimeType

                var image = if(mimeType == ContentType.IMAGE_GIF.mimeType){
                    val gifDecoder = GifDecoder()
                    gifDecoder.read(stream)
                    gifDecoder.getFrame(0)
                }else{
                    ImageIO.read(stream)
                }

                if(image == null){
                    for(j in 1..10){
                        val tempUrl = URL(url)
                        image = ImageIO.read(tempUrl)
                        if(image != null){
                            break
                        }
                    }
                }else{
                    val bufferedImage = BufferedImage(image.width, image.height, BufferedImage.TYPE_INT_BGR)
                    val graphics = bufferedImage.graphics as Graphics2D
                    graphics.background = Color.WHITE
                    graphics.drawImage(image, 0, 0, null)
                    val commonCDDto = Tblmi_comm_cdDto()
                    commonCDDto.grp_id = "COMMON"
                    commonCDDto.cd_id = "UPURL01"
                    val uploadPrefix = sysSettingDao.getCommCD(commonCDDto);

                    val realPah = uploadPrefix?.cd_val+"/"+localPath.substring(localPath.lastIndexOf("image"))

                    ImageIO.write(bufferedImage, file_ext!!.substring(1), File(FilenameUtils.normalize(localPath), FilenameUtils.getName(inDate + i.toString() + file_ext)))
                    str2 = str2.replace(url, "$realPah/$inDate$i$file_ext")
                    rlist.add("$localPath/$inDate$i$file_ext")
                    stream.close()
                    stream = null
                }
            } catch (e: Exception) {
                logger.error("img File :", e)
            } finally {
                i++
                try {
                    stream?.close()
                } catch (e: IOException) {
                }
            }
        }
        return str2
    }
    fun file_ext(url: String): String? {
        val p = Pattern.compile("\\.(jpg|jpeg|png|gif)", Pattern.CASE_INSENSITIVE)
        val m = p.matcher(url)
        return if (m.find()) {
            m.group(0)
        } else {
            ".jpg"
        }
    }

}

private fun String.matches(regex: String): Boolean {
    return Pattern.matches(regex, this)
}
