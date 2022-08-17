package com.omnilab.micrm.config

import com.google.common.collect.ImmutableSet
import com.omnilab.micrm.config.handler.AuthenticationHandler
import com.omnilab.micrm.config.handler.LoginFailHandler
import com.omnilab.micrm.config.handler.LoginSuccessHandler
import com.omnilab.micrm.service.CustomAuthenticationProvider
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Qualifier
import org.springframework.boot.web.servlet.FilterRegistrationBean
import org.springframework.context.annotation.Bean
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder
import org.springframework.security.config.annotation.web.builders.HttpSecurity
import org.springframework.security.config.annotation.web.builders.WebSecurity
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter
import org.springframework.security.config.http.SessionCreationPolicy
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder
import org.springframework.security.crypto.password.PasswordEncoder
import org.springframework.security.web.csrf.CsrfFilter
import org.springframework.security.web.firewall.HttpFirewall
import org.springframework.security.web.firewall.StrictHttpFirewall
import org.springframework.security.web.header.HeaderWriter
import org.springframework.security.web.header.writers.frameoptions.XFrameOptionsHeaderWriter
import org.springframework.security.web.header.writers.frameoptions.XFrameOptionsHeaderWriter.XFrameOptionsMode
import org.springframework.web.filter.CharacterEncodingFilter
import java.util.*
import javax.servlet.DispatcherType
import javax.servlet.Filter
import javax.servlet.http.HttpServletRequest
import javax.servlet.http.HttpServletResponse


@EnableWebSecurity
class SecurityConfig: WebSecurityConfigurerAdapter() {

    @Autowired
    private lateinit var authenticationhandler: AuthenticationHandler

    @Autowired
    private lateinit var customAuthenticationProvider: CustomAuthenticationProvider

    @Throws(Exception::class)
    override fun configure(web: WebSecurity) {
        super.configure(web)
        web.ignoring().antMatchers("/font/**", "/css/**", "/js/**", "/image/**", "/inc/**", "/js/**", "/static/favicon.ico", "/html/**", "/*.ico")
        web.httpFirewall(allowUrlHttpFirewall())
    }

    @Throws(Exception::class)
    override fun configure(httpSecurity: HttpSecurity) {
        val filter = CharacterEncodingFilter()
        filter.encoding = "UTF-8"
        filter.setForceEncoding(true)
        httpSecurity.addFilterBefore(filter, CsrfFilter::class.java)
                .csrf().ignoringAntMatchers("/rest/**", "/api/**", "/sf/**")
            .and()
                .authorizeRequests().antMatchers("/", "/index.mi", "/login.service", "/logout.service", "/error","/mcr/check/id.ajax" ,"/mcr/find/pw.ajax","/mcr/send/password.service", "/check.mi", "/error.mi", "/sf/**")
                .permitAll()
            .and()
                .authorizeRequests().anyRequest().authenticated()
                // 로그인 설정
            .and()
                .formLogin()
                .loginPage("/index.mi")
                .loginProcessingUrl("/login.service")
                .usernameParameter("id")
                .passwordParameter("password")
                .successHandler(LoginSuccessHandler())
                .failureHandler(LoginFailHandler())
                // 로그아웃 설정
            .and()
                .logout()
                .logoutUrl("/logout.service")
                .logoutSuccessUrl("/index.mi")
                .invalidateHttpSession(true)
                .deleteCookies("JSESSIONID", "MICRMRE")
                // 해들링 설정
            .and()
                .exceptionHandling()
                .authenticationEntryPoint(authenticationhandler)
                .accessDeniedHandler(authenticationhandler)
                // remember me 설정
            .and()
                .rememberMe()
                .key("micrm")
                .rememberMeParameter("remember_me")
                .rememberMeCookieName("MICRMRE")
                .tokenValiditySeconds(864000)
            .and()
                .sessionManagement()
                .sessionCreationPolicy(SessionCreationPolicy.NEVER)
            .and()
                .headers().frameOptions().disable().addHeaderWriter(CustomXFrameOptionsHeaderWriter())
    }

    @Throws(Exception::class)
    override fun configure(auth: AuthenticationManagerBuilder) {
        auth.authenticationProvider(customAuthenticationProvider)
    }

    @Bean
    fun getSpringSecurityFilterChainBindedToError(@Qualifier("springSecurityFilterChain") springSecurityFilterChain: Filter): FilterRegistrationBean<*> {
        val registration = FilterRegistrationBean<Filter>()
        registration.filter = springSecurityFilterChain
        registration.setDispatcherTypes(EnumSet.allOf(DispatcherType::class.java))
        return registration
    }

    @Bean
    fun passwordEncoder(): PasswordEncoder {
        return BCryptPasswordEncoder()
    }

    @Bean
    fun allowUrlHttpFirewall(): HttpFirewall {
        val firewall = StrictHttpFirewall()
        //firewall.setAllowUrlEncodedPercent(true);
        //firewall.setAllowSemicolon(true)
        firewall.setAllowUrlEncodedSlash(true)
        firewall.setAllowUrlEncodedDoubleSlash(true)
        return firewall
    }

    private class CustomXFrameOptionsHeaderWriter : HeaderWriter {
        private val defaultHeaderWriter: XFrameOptionsHeaderWriter = XFrameOptionsHeaderWriter(XFrameOptionsMode.SAMEORIGIN)
        private val allowUrl: String = "\\/sf\\/.*"
        private val log = LoggerFactory.getLogger(this.javaClass)

        override fun writeHeaders(req: HttpServletRequest, rep: HttpServletResponse) {
            log.error("Referer : {}", req.getHeader("Referer"))
            log.error("HOST : {}", req.getHeader("HOST"))
            log.error("X-FORWARDED-HOST : {}", req.getHeader("X-FORWARDED-HOST"))

            if (!req.requestURI.contains(allowUrl)) {
                defaultHeaderWriter.writeHeaders(req, rep)
            }
        }
    }

}