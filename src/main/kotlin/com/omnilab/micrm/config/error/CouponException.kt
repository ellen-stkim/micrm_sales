package com.omnilab.micrm.config.error

import org.springframework.http.HttpStatus

class CouponException(httpStatus: HttpStatus, message: String) : RuntimeException() {

    var httpStatus: HttpStatus = httpStatus
    override var message: String = message

}