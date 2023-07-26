package com.omnilab.micrm.common

import io.minio.MinioClient
import io.minio.UploadObjectArgs
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Value
import org.springframework.stereotype.Component
import org.springframework.web.multipart.MultipartFile
import java.io.File
import java.io.FileOutputStream
import javax.servlet.http.HttpServletRequest

@Component("FileUploadUtils")
class FileUploadUtils {
    val logger = LoggerFactory.getLogger(this::class.java)

    @Value("\${variable.minio-url}")
    private lateinit var minioUrl: String

    @Value("\${variable.minio-username}")
    private lateinit var minioUsername: String

    @Value("\${variable.minio-password}")
    private lateinit var minioPassword: String

    @Value("\${variable.minio-bucket}")
    private lateinit var minioBucket: String

    @Value("\${variable.static-path}")
    private lateinit var staticPath: String

    @Value("\${upload.content}")
    private lateinit var filePath: String

    @Value("\${upload.upd_content}")
    private lateinit var updPath: String

    fun upload(usrCd:String, file: MultipartFile): MutableMap<String, Any> {
        val curFilePath = "$filePath/$usrCd"
        val updFildPath = "$updPath/$usrCd"
        val saveFile = File(curFilePath)
        if (!saveFile.exists()) {
            saveFile.mkdirs()
        }
        val map: MutableMap<String, Any> = HashMap()
        try {
            val fileMime = CommonUtils.checkImageMime(file);
            if (!CommonUtils.isEmptyObject(fileMime)) {
                var fileName: String? = file.originalFilename
                val fileExe = fileName?.substring(fileName.lastIndexOf(".") + 1)
                val digits = CommonUtils.getRandString16()
                fileName = "$digits.$fileExe"

                if (fileupload(curFilePath,file, fileName)) {
                    val minioClient = MinioClient.builder().endpoint(minioUrl).credentials(minioUsername, minioPassword).build()
                    minioClient.uploadObject(
                        UploadObjectArgs.builder()
                            .bucket(minioBucket)
                            .`object`("$usrCd/$fileName")
                            .filename(staticPath + "$updFildPath/$fileName")
                            .build())

                    map["uploaded"] = 1
                    map["message"] = "파일 업로드 성공"
                    map["fileName"] = file.originalFilename.toString()
                    map["file_nm"] = fileName
                    map["file_extention"] = fileExe.toString()
                    map["file_mime"] = file.getContentType().toString()
                    map["url"] = curFilePath.substring(curFilePath.lastIndexOf("image")-1)+"/"+ fileName
                } else {
                    map["uploaded"] = 0
                    map["message"] = "파일 업로드 실패, 다시 시도해주세요."
                }
            } else {
                map["uploaded"] = 0
                map["message"] = "업로드는 jpg, jpeg, gif, bmp, png 만 가능합니다."
            }
        } catch (e: Exception) {
            logger.error("File Upload :", e)
            map["uploaded"] = 0
            map["message"] = "파일 업로드 실패"
            return map;
        }
        return map
    }

    fun fileupload(curFilePath:String, file: MultipartFile, fileName: String): Boolean {
        val saveFile = File(curFilePath)

        if (!saveFile.exists()) {
            saveFile.mkdirs()
        }
        var fos: FileOutputStream? = null
        return try {
            val fileByte: ByteArray = file.bytes
            fos = FileOutputStream("$curFilePath/$fileName")
            fos.write(fileByte)
            fos.close()
            true
        } catch (e: Exception) {
            logger.info("File Upload false : ", e)
            fos?.close()
            false
        }
    }

    fun fileDelete(curFilePath:String?, fileName: String): String {
        val file = File("$curFilePath/$fileName")
        return if (file.exists()) {
            if(file.delete()){
                "$curFilePath/$fileName 삭제"
            }else{
                "$curFilePath/$fileName 삭제 실패"
            }
        }else{
            "삭제할 파일이 없습니다."
        }

    }

}

