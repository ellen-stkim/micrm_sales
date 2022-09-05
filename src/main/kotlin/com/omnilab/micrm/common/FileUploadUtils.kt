package com.omnilab.micrm.common

import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Value
import org.springframework.context.annotation.ComponentScan
import org.springframework.stereotype.Component
import org.springframework.web.multipart.MultipartFile
import java.io.File
import java.io.FileOutputStream
import javax.servlet.http.HttpServletRequest

@Component("FileUploadUtils")
class FileUploadUtils {
    val logger = LoggerFactory.getLogger(this::class.java)

    fun upload(filePath:String, file: MultipartFile, request: HttpServletRequest): MutableMap<String, Any> {
        val saveFile = File(filePath)
        if (!saveFile.exists()) {
            logger.info("폴더생성")
            saveFile.mkdirs()
        }
        logger.info("Upload start")
        val map: MutableMap<String, Any> = HashMap()
        try {
            val fileMime = CommonUtils.checkImageMime(file);
            if (!CommonUtils.isEmptyObject(fileMime)) {
                var fileName: String? = file.originalFilename
                val fileExe = fileName?.substring(fileName.lastIndexOf(".") + 1)
                val digits = CommonUtils.getRandString16()
                fileName = "$digits.$fileExe"

                if (fileupload(filePath,file, fileName)) {
                    map["uploaded"] = 1
                    map["message"] = "파일 업로드 성공"
                    map["fileName"] = file.originalFilename.toString()
                    map["file_nm"] = fileName
                    map["file_extention"] = fileExe.toString()
                    map["file_mime"] = file.getContentType().toString();
                    map["url"] = filePath.substring(filePath.lastIndexOf("image")-1)+"/"+ fileName
                } else {
                    map["uploaded"] = 0
                    map["message"] = "파일 업로드 실패, 다시 시도해주세요."
                }
            } else {
                logger.info("File image mime check :$fileMime")
                map["uploaded"] = 0
                map["message"] = "업로드는 jpg, jpeg, gif, bmp, png 만 가능합니다."
            }
        } catch (e: Exception) {
            logger.info("File Upload :" + e.message)
            map["uploaded"] = 0
            map["message"] = "파일 업로드 실패"
            return map;
        }
        return map
    }

    fun fileupload(filePath:String, file: MultipartFile, fileName: String): Boolean {
        val saveFile = File(filePath)

        if (!saveFile.exists()) {
            logger.info("폴더생성")
            saveFile.mkdirs()
        }
        var fos: FileOutputStream? = null
        try {
            val fileByte: ByteArray = file.bytes
            fos = FileOutputStream("$filePath/$fileName")
            fos.write(fileByte)
            fos.close()
            return true
        } catch (e: Exception) {
            logger.info("File Upload false : " + e.message)
            fos?.close()
            return false
        }
    }

    fun fileDelete(filePath:String?, fileName: String): String {
        val file = File("$filePath/$fileName")
        if (file.exists()) {
            file.delete()
            return "$filePath/$fileName 삭제"
        }else{
            return "삭제할 파일이 없습니다."
        }

    }

}

