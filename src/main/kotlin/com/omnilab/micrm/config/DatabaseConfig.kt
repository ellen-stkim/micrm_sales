package com.omnilab.micrm.config

import com.zaxxer.hikari.HikariDataSource
import net.sf.log4jdbc.log.slf4j.Slf4jSpyLogDelegator
import net.sf.log4jdbc.sql.jdbcapi.DataSourceSpy
import org.apache.ibatis.session.SqlSession
import org.apache.ibatis.session.SqlSessionFactory
import org.aspectj.lang.annotation.Aspect
import org.mybatis.spring.SqlSessionFactoryBean
import org.mybatis.spring.SqlSessionTemplate
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Qualifier
import org.springframework.beans.factory.annotation.Value
import org.springframework.context.ApplicationContext
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.context.annotation.EnableAspectJAutoProxy
import org.springframework.jdbc.datasource.DataSourceTransactionManager
import org.springframework.transaction.annotation.EnableTransactionManagement
import org.springframework.transaction.interceptor.*
import java.util.*
import javax.sql.DataSource
import kotlin.jvm.Throws

@Aspect
@EnableAspectJAutoProxy
@Configuration
@EnableTransactionManagement
internal class DatabaseConfig {

    @Autowired
    private lateinit var applicationContext: ApplicationContext

    @Value("\${variable.db-class}")
    private lateinit var dbClass: String

    @Value("\${variable.db-url}")
    private lateinit var dbUrl: String

    @Value("\${variable.db-username}")
    private lateinit var dbUsername: String

    @Value("\${variable.db-password}")
    private lateinit var dbPassword: String

    @Bean(name = ["ds"], destroyMethod = "close")
    fun ds(): HikariDataSource {
        val dataSource = HikariDataSource()
        dataSource.driverClassName = dbClass
        dataSource.jdbcUrl = dbUrl
        dataSource.username = dbUsername
        dataSource.password = dbPassword
        dataSource.minimumIdle = 1
        dataSource.maximumPoolSize = 50
        dataSource.connectionTestQuery = "select 1"
        dataSource.connectionTimeout = 15000
        dataSource.validationTimeout = 60000
        return dataSource
    }

    @Bean("dataSource")
    fun dataSource(@Qualifier("ds") dataSource: DataSource): DataSource {
        val dataSourceSpy = DataSourceSpy(dataSource)
        dataSourceSpy.logDelegator = Slf4jSpyLogDelegator()
        return dataSourceSpy
    }

    @Bean("transactionManager")
    fun transactionManager(@Qualifier("dataSource") dataSource: DataSource): DataSourceTransactionManager {
        val transactionManager = DataSourceTransactionManager(dataSource)
        transactionManager.isGlobalRollbackOnParticipationFailure = false
        return transactionManager
    }

    @Bean(name = ["sqlSessionFactory"])
    @Throws(Exception::class)
    fun sqlSessionFactory(@Qualifier("dataSource") dataSource: DataSource): SqlSessionFactory? {
        val sessionFactoryBean = SqlSessionFactoryBean()
        sessionFactoryBean.setDataSource(dataSource)
        sessionFactoryBean.setTypeAliasesPackage("com.omnilab.micrm.model")
        sessionFactoryBean.setConfigLocation(applicationContext.getResource("classpath:mybatis/mybatis-config.xml"))
        sessionFactoryBean.setMapperLocations(*applicationContext.getResources("classpath:mybatis/mapper/*.xml"))
        return sessionFactoryBean.getObject()
    }

    @Bean(name = ["sqlSession"], destroyMethod = "clearCache")
    @Throws(Exception::class)
    fun sqlSession(@Qualifier("sqlSessionFactory") sqlSessionFactory: SqlSessionFactory): SqlSession {
        val sqlSession = SqlSessionTemplate(sqlSessionFactory)
        return sqlSession
    }
}
