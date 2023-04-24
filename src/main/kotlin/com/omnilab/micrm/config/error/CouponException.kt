package com.omnilab.micrm.config.error

import org.springframework.http.HttpStatus

class CouponException(httpStatus: HttpStatus, location: String, message: String) : RuntimeException() {

    var httpStatus: HttpStatus = httpStatus
    var location: String = location
    override var message: String = message

}