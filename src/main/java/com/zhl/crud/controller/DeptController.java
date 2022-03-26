package com.zhl.crud.controller;

import com.zhl.crud.bean.Dept;
import com.zhl.crud.bean.Msg;
import com.zhl.crud.service.DeptService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

/**
 * @date 2022/3/23 13:20
 **/
@Controller
public class DeptController {
    @Autowired
    private DeptService deptService;

    //返回所有部门信息
    @RequestMapping("/depts")
    @ResponseBody
    public Msg getDepts(){
        List<Dept> deptList=deptService.getDepts();
        return Msg.success().add("depts",deptList);
    }
}
