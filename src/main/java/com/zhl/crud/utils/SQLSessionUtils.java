package com.zhl.crud.utils;

import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;

import java.io.IOException;
import java.io.InputStream;

///**
// * @date 2022/3/20 14:40
// **/
//public class SQLSessionUtils {
//    public static SqlSession getSqlSession(){
//        SqlSession sqlSession= null;
//        try {
//            InputStream resourceAsStream = Resources.getResourceAsStream("mybatis_config.xml");
//            SqlSessionFactoryBuilder sqlSessionFactoryBuilder = new SqlSessionFactoryBuilder();
//            SqlSessionFactory sqlSessionFactory = sqlSessionFactoryBuilder.build(resourceAsStream);
//            sqlSession = sqlSessionFactory.openSession(true);
//        } catch (IOException e) {
//            e.printStackTrace();
//        }
//        return sqlSession;
//    }
//}
