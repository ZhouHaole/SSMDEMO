package com.zhl.crud.controller;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.zhl.crud.bean.Employee;
import com.zhl.crud.bean.Msg;
import com.zhl.crud.service.EmployeeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

/**
 * 处理员工crud请求
 * @date 2022/3/20 17:21
 **/
@Controller
public class EmpController {

    @Autowired
    EmployeeService employeeService;


    //返回一个json给客户端,需要导入一个json包
    @RequestMapping("/emps")
    @ResponseBody
    public Msg getEmpWithJson(@RequestParam(value = "pn",defaultValue = "1")Integer pn){

        PageHelper.startPage(pn,5);
        List<Employee> employeeList=employeeService.getAll();
        PageInfo page=new PageInfo(employeeList,5);
        return Msg.success().add("pageInfo",page);
    }

    /**
     * 员工保存
     * 1.支持JSR303校验
     * 2.导入Hibernate_Validator
     */
    @RequestMapping(value = "/empSave",method = RequestMethod.POST)
    @ResponseBody
    public Msg saveEmployee(@Valid Employee employee, BindingResult result){
        if(result.hasErrors()){
            //校验失败,在模态框中显示校验失败的信息
            List<FieldError> fieldErrors = result.getFieldErrors();
            HashMap<String, Object> map = new HashMap<>();
            for (FieldError fieldError:fieldErrors) {
                System.out.println("错误的字段名:"+fieldError.getField());
                System.out.println("错误信息"+fieldError.getDefaultMessage());
                map.put(fieldError.getField(),fieldError.getDefaultMessage());
            }
            return Msg.fail().add("errorFields",map);
        }
        employeeService.saveEmp(employee);
        return Msg.success();
    }

    /**
     * ajax检查用户名是否重名
     */
    @RequestMapping("/checkUser")
    @ResponseBody
    public Msg checkUser(@RequestParam("empName") String empName){
         String regName="(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5}$)";
         if(!empName.matches(regName)){
                return Msg.fail().add("vg","用户名格式不正确");
         }
         if(employeeService.checkUser(empName)){
                return Msg.success();
         }else {
                return Msg.fail().add("vg","用户名已重名");
         }
    }

    //修改键查询员工
    @RequestMapping(value = "/getEmp/{id}",method = RequestMethod.GET)
    @ResponseBody
    public Msg getEmp(@PathVariable("id") Integer id){
            Employee employee=employeeService.getEmp(id);
        return Msg.success().add("emp",employee);
    }

    //修改员工
    @RequestMapping(value = "/updateEmp/{empId}",method = RequestMethod.PUT)
    @ResponseBody
    public Msg updateEmp(Employee employee){
        employeeService.updateEmp(employee);
        return Msg.success();
    }


    //单个批量二合一删除
    @RequestMapping(value = "/delete/{ids}",method = RequestMethod.DELETE)
    @ResponseBody
    public Msg deleteEmp(@PathVariable("ids")String ids){
        if (ids.contains("-")){
            List<Integer> idsInt=new ArrayList<Integer>();
            String[] idsList=ids.split("-");
            for (String str:idsList) {
                idsInt.add(Integer.parseInt(str));
            }
            employeeService.deleteEmpList(idsInt);
        }else {
            int i = Integer.parseInt(ids);
            employeeService.deleteEmp(i);
        }
        return Msg.success();
    }















    /**
     * 查询员工所有数据并且进行分页
     * @return
     */
    //@RequestMapping(value = "/emps")
    //public String getEmpList(@RequestParam(value = "pn",defaultValue = "1")Integer pn,Model model){
    //    //这不是分页查询
    //    //引入pageHelper分页插件
    //    //显示第pn页,每页5条数据
    //    PageHelper.startPage(pn,5);
    //    List<Employee> employeeList=employeeService.getAll();
    //    //数字导航页码为5个,把employeeList所有信息包装到pageInfo里并传给页面
    //    PageInfo page=new PageInfo(employeeList,5);
    //    model.addAttribute("pageInfo",page);
    //    return "list";
    //
    //}

}
