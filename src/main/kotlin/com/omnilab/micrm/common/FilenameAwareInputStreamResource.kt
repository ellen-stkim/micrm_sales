package com.omnilab.micrm.common

import org.springframework.core.io.InputStreamResource
import java.io.InputStream

class FilenameAwareInputStreamResource(inputStream: InputStream, private val contentLength: Long, private val filename: String) : InputStreamResource(inputStream) {

    override fun getFilename(): String? {
        return filename
    }

    override fun contentLength(): Long {
        return contentLength
    }
}