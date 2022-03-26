package com.zhl.crud.service;

import com.zhl.crud.bean.Dept;
import com.zhl.crud.dao.DeptMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @date 2022/3/23 13:21
 **/
@Service
public class DeptService {
    @Autowired
    private DeptMapper deptMapper;

    public List<Dept> getDepts(){
        List<Dept> list=deptMapper.selectByExample(null);
        return list;
    }

}
