package com.omnilab.micrm.config

import com.zaxxer.hikari.HikariDataSource
import net.sf.log4jdbc.log.slf4j.Slf4jSpyLogDelegator
import net.sf.log4jdbc.sql.jdbcapi.DataSourceSpy
import org.apache.ibatis.session.SqlSession
import org.apache.ibatis.session.SqlSessionFactory
import org.aspectj.lang.annotation.Aspect
import org.mybatis.spring.SqlSessionFactoryBean
import org.mybatis.spring.SqlSessionTemplate
import org.slf4j.LoggerFactory
import org.springframework.aop.Advisor
import org.springframework.aop.aspectj.AspectJExpressionPointcut
import org.springframework.aop.support.DefaultPointcutAdvisor
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Value
import org.springframework.context.ApplicationContext
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.context.annotation.EnableAspectJAutoProxy
import org.springframework.jdbc.BadSqlGrammarException
import org.springframework.jdbc.datasource.DataSourceTransactionManager
import org.springframework.transaction.TransactionDefinition
import org.springframework.transaction.annotation.EnableTransactionManagement
import org.springframework.transaction.interceptor.*
import java.sql.SQLException
import java.util.*
import javax.sql.DataSource
import kotlin.jvm.Throws

@Aspect
@EnableAspectJAutoProxy
@Configuration
@EnableTransactionManagement
internal class DatabaseConfig {

    private val log = LoggerFactory.getLogger(this.javaClass)

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

    @Bean
    fun dataSource(): DataSource {
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

        val dataSourceSpy = DataSourceSpy(dataSource)
        dataSourceSpy.logDelegator = Slf4jSpyLogDelegator()
        return dataSourceSpy
    }

    @Bean
    fun transactionManager(): DataSourceTransactionManager {
        val transactionManager = DataSourceTransactionManager(dataSource())
        transactionManager.isGlobalRollbackOnParticipationFailure = false
        transactionManager.isRollbackOnCommitFailure
        return transactionManager
    }

    @Bean
    fun txAdvice(): TransactionInterceptor {
        val txAdvice = TransactionInterceptor()
        val txAttributes = Properties()

        val rollbackRules = ArrayList<RollbackRuleAttribute>()
        rollbackRules.add(RollbackRuleAttribute(java.lang.Exception::class.java))
        rollbackRules.add(RollbackRuleAttribute(SQLException::class.java))
        rollbackRules.add(RollbackRuleAttribute(BadSqlGrammarException::class.java))
        rollbackRules.add(RollbackRuleAttribute(Exception::class.java))

        //val readOnlyAttribute = DefaultTransactionAttribute(TransactionDefinition.PROPAGATION_REQUIRED)
        val readOnlyAttribute = DefaultTransactionAttribute(TransactionDefinition.PROPAGATION_REQUIRES_NEW)
        readOnlyAttribute.isReadOnly = true

        //readOnlyAttribute.setTimeout(10);
        readOnlyAttribute.timeout = -1

        //val writeAttribute = RuleBasedTransactionAttribute(TransactionDefinition.PROPAGATION_REQUIRES_NEW, rollbackRules)
        val writeAttribute = RuleBasedTransactionAttribute(TransactionDefinition.PROPAGATION_REQUIRES_NEW, rollbackRules)
        writeAttribute.timeout = -1

        val readOnlyTransactionAttributesDefinition = readOnlyAttribute.toString()
        val writeTransactionAttributesDefinition = writeAttribute.toString()
        //log.error("Read Only Attributes :: {}", readOnlyTransactionAttributesDefinition);
        //log.error("Write Attributes :: {}", writeTransactionAttributesDefinition);

        // read-only
        txAttributes.setProperty("sel*", readOnlyTransactionAttributesDefinition)
        txAttributes.setProperty("get*", readOnlyTransactionAttributesDefinition)
        txAttributes.setProperty("list*", readOnlyTransactionAttributesDefinition)
        txAttributes.setProperty("count*", readOnlyTransactionAttributesDefinition)

        // write rollback-rule
        txAttributes.setProperty("*", writeTransactionAttributesDefinition)
        txAdvice.setTransactionAttributes(txAttributes)
        txAdvice.transactionManager = transactionManager()
        return txAdvice
    }

    @Bean
    fun txAdviceAdvisor(): Advisor {
        val pointcut = AspectJExpressionPointcut()
        pointcut.expression = "execution(* com.omnilab.micrm.service..*.*(..))"
        //pointcut.expression = "execution(* com.omnilab.micrm.repository..*.*(..))"
        return DefaultPointcutAdvisor(pointcut, txAdvice())
    }

    @Bean(name = ["sqlSessionFactory"])
    @Throws(Exception::class)
    fun sqlSessionFactory(): SqlSessionFactory? {
        val sessionFactoryBean = SqlSessionFactoryBean()
        sessionFactoryBean.setDataSource(dataSource())
        sessionFactoryBean.setTypeAliasesPackage("com.omnilab.micrm.model")
        sessionFactoryBean.setConfigLocation(applicationContext.getResource("classpath:mybatis/mybatis-config.xml"))
        sessionFactoryBean.setMapperLocations(*applicationContext.getResources("classpath:mybatis/mapper/*.xml"))
        return sessionFactoryBean.getObject()
    }

    @Bean(name = ["sqlSession"], destroyMethod = "clearCache")
    @Throws(Exception::class)
    fun sqlSession(): SqlSession {
        val sqlSession = SqlSessionTemplate(sqlSessionFactory()!!)
        return sqlSession
    }
}
