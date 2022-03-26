package com.zhl.crud.test;

import com.zhl.crud.bean.Dept;
import com.zhl.crud.bean.Employee;
import com.zhl.crud.dao.DeptMapper;
import com.zhl.crud.dao.EmployeeMapper;
import org.apache.ibatis.session.SqlSession;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.util.UUID;

/**
 * 测试dao层
 * @date 2022/3/20 14:40
 * 1.导入springTest模块
 * 2.@ContextConfiguration指定spring配置文件的位置
 **/
@RunWith(value = SpringJUnit4ClassRunner.class)      //只用spring单元测试
@ContextConfiguration(locations = {"classpath:applicationContext.xml"})  //注解获取ioc容器等同于ApplicationContext ioc = new ClassPathXmlApplicationContext("applicationContext.xml");
public class testSQL {
    /**
     * 测试DeptMapper
     */
    @Autowired
    DeptMapper deptMapper;  //等于DeptMapper bean = ioc.getBean(DeptMapper.class);

    @Autowired
    EmployeeMapper employeeMapper;

    @Autowired
    SqlSession sqlSession;

    @Test
    public void testCrud(){
//        //1.创建springIOC容器
//        ApplicationContext ioc = new ClassPathXmlApplicationContext("applicationContext.xml");
//        //2.从容器中获取mapper
//        DeptMapper bean = ioc.getBean(DeptMapper.class);

//        System.out.println(deptMapper);
//        //1.插入几个部门
//        deptMapper.insertSelective(new Dept(null,"开发部"));
//        deptMapper.insertSelective(new Dept(null,"测试部"));
        //2.添加一个员工
//        employeeMapper.insertSelective(new Employee(null,"Jerry","男","Jerry@qq.com",1));
        //3.批量插入员工,可以执行
        EmployeeMapper mapper = sqlSession.getMapper(EmployeeMapper.class);
        for(int i=0;i<1000;i++){
            String uid= UUID.randomUUID().toString().substring(0,5);
            mapper.insertSelective(new Employee(null,uid,"男",uid+"@qq.com",1));
        }
    }
}
