package com.zhl.crud.service;

import com.zhl.crud.bean.Employee;
import com.zhl.crud.bean.EmployeeExample;
import com.zhl.crud.dao.EmployeeMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @date 2022/3/20 17:25
 **/
@Service
public class EmployeeService {
    @Autowired
    EmployeeMapper employeeMapper;

    //查询所有员工
    public List<Employee> getAll() {
        return employeeMapper.selectByExampleWithDept(null);
    }

    public void saveEmp(Employee employee) {
        employeeMapper.insertSelective(employee);
    }

    public boolean checkUser(String empName) {
        EmployeeExample employeeExample = new EmployeeExample();
        employeeExample.createCriteria().andEmpNameEqualTo(empName);
        long i = employeeMapper.countByExample(employeeExample);
        return i==0;
    }

    public Employee getEmp(Integer id) {
        Employee employee = employeeMapper.selectByPrimaryKey(id);
        return employee;
    }

    public void updateEmp(Employee employee) {
        employeeMapper.updateByPrimaryKeySelective(employee);
    }

    public void deleteEmp(Integer empId) {
        employeeMapper.deleteByPrimaryKey(empId);
    }

    public void deleteEmpList(List<Integer> ids) {
        EmployeeExample employeeExample = new EmployeeExample();
        EmployeeExample.Criteria criteria = employeeExample.createCriteria();
        criteria.andEmpIdIn(ids);
        employeeMapper.deleteByExample(employeeExample);
    }
}
