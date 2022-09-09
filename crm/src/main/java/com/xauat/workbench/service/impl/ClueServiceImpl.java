package com.xauat.workbench.service.impl;

import com.xauat.commoms.constants.Constants;
import com.xauat.commoms.utils.UUIDUtils;
import com.xauat.settings.pojo.User;
import com.xauat.workbench.mapper.*;
import com.xauat.workbench.pojo.*;
import com.xauat.workbench.service.ClueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

@Service
public class ClueServiceImpl implements ClueService {

    @Autowired
    private ClueMapper clueMapper;

    @Autowired
    private CustomerMapper customerMapper;

    @Autowired
    private ContactsMapper contactsMapper;

    @Autowired
    private ClueRemarkMapper clueRemarkMapper;

    @Autowired
    private CustomerRemarkMapper customerRemarkMapper;

    @Autowired
    private ContactsRemarkMapper contactsRemarkMapper;

    @Autowired
    private ClueActivityRelationMapper clueActivityRelationMapper;

    @Autowired
    private ContactsActivityRelationMapper contactsActivityRelationMapper;

    @Autowired
    private TransactionMapper transactionMapper;

    @Autowired
    private TransactionRemarkMapper transactionRemarkMapper;

    @Autowired
    private TransactionHistoryMapper transactionHistoryMapper;

    @Override
    public int saveCreateClue(Clue clue) {
        return clueMapper.insertCreateClue(clue);
    }

    @Override
    public List<Clue> queryClueByConditionsForPage(Map<String, Object> map) {
        return clueMapper.selectClueByConditionsForPage(map);
    }

    @Override
    public int queryClueCountByConditions(Map<String, Object> map) {
        return clueMapper.selectClueCountByConditions(map);
    }

    @Override
    public Clue queryClueById(String id) {
        return clueMapper.selectClueById(id);
    }

    @Override
    public int saveEditClue(Clue clue) {
        return clueMapper.updateClue(clue);
    }

    @Override
    public int deleteClueByIds(String[] ids) {
        return clueMapper.deleteClueByIds(ids);
    }

    @Override
    public Clue queryClueDetailById(String id) {
        return clueMapper.selectClueDetailById(id);
    }

    @Override
    public void saveConvertClue(Map<String, Object> map) {
        User user = (User) map.get(Constants.SESSION_USER);
        String clueId = (String) map.get("clueId");
        String isCreateTransaction = (String) map.get("isCreateTransaction");
        Clue clue = clueMapper.selectClueById(clueId);
        //把线索中有关公司的信息转换到客户表中
        //先根据线索中的公司名字查询数据库中是否已存在此公司（公司名字是唯一的），如果不存在，新建客户
        Customer customer = customerMapper.selectCustomerByName(clue.getCompany());
        if(customer == null){
            customer = new Customer();
            customer.setId(UUIDUtils.getUUID32());
            customer.setOwner(clue.getOwner());
            customer.setName(clue.getCompany());
            customer.setWebsite(clue.getWebsite());
            customer.setPhone(clue.getPhone());
            customer.setCreateBy(user.getId());
            customer.setCreateTime(new Date());
            customer.setContactSummary(clue.getContactSummary());
            customer.setNextContactTime(clue.getNextContactTime());
            customer.setDescription(clue.getDescription());
            customer.setAddress(clue.getAddress());
            customerMapper.insertCustomer(customer);
        }
        //把线索中有关个人的信息转换到联系人表中
        Contacts contacts = new Contacts();
        contacts.setId(UUIDUtils.getUUID32());
        contacts.setOwner(clue.getOwner());
        contacts.setSource(clue.getSource());
        contacts.setCustomerId(customer.getId());
        contacts.setFullname(clue.getFullname());
        contacts.setAppellation(clue.getAppellation());
        contacts.setEmail(clue.getEmail());
        contacts.setMphone(clue.getMphone());
        contacts.setJob(clue.getJob());
        contacts.setCreateBy(user.getId());
        contacts.setCreateTime(new Date());
        contacts.setDescription(clue.getDescription());
        contacts.setContactSummary(clue.getContactSummary());
        contacts.setNextContactTime(clue.getNextContactTime());
        contacts.setAddress(clue.getAddress());
        contactsMapper.insertContacts(contacts);
        //把线索的备注信息转换到客户备注表中一份
        //把线索的备注信息转换到联系人备注表中一份
        List<ClueRemark> clueRemarkList = clueRemarkMapper.selectClueRemarkByClueId(clueId);
        if(clueRemarkList != null && clueRemarkList.size() > 0){
            CustomerRemark customerRemark = null;
            ContactsRemark contactsRemark = null;
            List<CustomerRemark> customerRemarkList = new ArrayList<>();
            List<ContactsRemark> contactsRemarkList = new ArrayList<>();
            for (ClueRemark clueRemark : clueRemarkList) {
                customerRemark = new CustomerRemark();
                customerRemark.setId(UUIDUtils.getUUID32());
                customerRemark.setNoteContent(clueRemark.getNoteContent());
                customerRemark.setCreateBy(clueRemark.getCreateBy());
                customerRemark.setCreateTime(clueRemark.getCreateTime());
                customerRemark.setEditBy(clueRemark.getEditBy());
                customerRemark.setEditTime(clueRemark.getEditTime());
                customerRemark.setEditFlag(clueRemark.getEditFlag());
                customerRemark.setCustomerId(customer.getId());
                customerRemarkList.add(customerRemark);

                contactsRemark = new ContactsRemark();
                contactsRemark.setId(UUIDUtils.getUUID32());
                contactsRemark.setNoteContent(clueRemark.getNoteContent());
                contactsRemark.setCreateBy(clueRemark.getCreateBy());
                contactsRemark.setCreateTime(clueRemark.getCreateTime());
                contactsRemark.setEditBy(clueRemark.getEditBy());
                contactsRemark.setEditTime(clueRemark.getEditTime());
                contactsRemark.setEditFlag(clueRemark.getEditFlag());
                contactsRemark.setContactsId(contacts.getId());
                contactsRemarkList.add(contactsRemark);
            }
            customerRemarkMapper.insertCustomerRemarkByList(customerRemarkList);
            contactsRemarkMapper.insertContactsRemarkByList(contactsRemarkList);
        }
        //把线索和市场活动的关联关系转换到联系人和市场活动的关联关系表中
        List<ClueActivityRelation> clueActivityRelationList = clueActivityRelationMapper.selectCARByClueId(clueId);
        if(clueActivityRelationList != null && clueActivityRelationList.size()>0){
            ContactsActivityRelation contactsActivityRelation = null;
            List<ContactsActivityRelation> contactsActivityRelationList = new ArrayList<>();
            for (ClueActivityRelation clueActivityRelation : clueActivityRelationList) {
                contactsActivityRelation = new ContactsActivityRelation();
                contactsActivityRelation.setId(UUIDUtils.getUUID32());
                contactsActivityRelation.setActivityId(clueActivityRelation.getActivityId());
                contactsActivityRelation.setContactsId(contacts.getId());
                contactsActivityRelationList.add(contactsActivityRelation);
            }
            contactsActivityRelationMapper.insertCARByList(contactsActivityRelationList);
        }
        //如果需要创建交易,还要往交易表中添加一条记录
        //如果需要创建交易,还要把线索的备注信息转换到交易备注表中一份
        //交易历史表中也要同步一条数据
        if("true".equals(isCreateTransaction)){
            Transaction transaction = new Transaction();
            transaction.setId(UUIDUtils.getUUID32());
            transaction.setOwner(user.getId());
            transaction.setMoney((String) map.get("money"));
            transaction.setName((String) map.get("name"));
            transaction.setExpectedDate((Date) map.get("expectedDate"));
            transaction.setCustomerId(customer.getId());
            transaction.setStage((String) map.get("stage"));
            transaction.setActivityId((String) map.get("activityId"));
            transaction.setContactsId(contacts.getId());
            transaction.setCreateBy(user.getId());
            transaction.setCreateTime(new Date());
            transactionMapper.insertTransaction(transaction);

            if(clueRemarkList != null && clueRemarkList.size() > 0){
                TransactionRemark transactionRemark = null;
                List<TransactionRemark> transactionRemarkList = new ArrayList<>();
                for (ClueRemark clueRemark : clueRemarkList) {
                    transactionRemark = new TransactionRemark();
                    transactionRemark.setId(UUIDUtils.getUUID32());
                    transactionRemark.setNoteContent(clueRemark.getNoteContent());
                    transactionRemark.setCreateBy(clueRemark.getCreateBy());
                    transactionRemark.setCreateTime(clueRemark.getCreateTime());
                    transactionRemark.setEditBy(clueRemark.getEditBy());
                    transactionRemark.setEditTime(clueRemark.getEditTime());
                    transactionRemark.setEditFlag(clueRemark.getEditFlag());
                    transactionRemark.setTranId(transaction.getId());
                    transactionRemarkList.add(transactionRemark);
                }
                transactionRemarkMapper.insertTransactionRemarkByList(transactionRemarkList);
            }

            TransactionHistory transactionHistory = new TransactionHistory();
            transactionHistory.setId(UUIDUtils.getUUID32());
            transactionHistory.setStage((String) map.get("stage"));
            transactionHistory.setMoney((String) map.get("money"));
            transactionHistory.setExpectedDate((Date) map.get("expectedDate"));
            transactionHistory.setCreateTime(new Date());
            transactionHistory.setCreateBy(user.getId());
            transactionHistory.setTranId(transaction.getId());
            transactionHistoryMapper.insertTransactionHistory(transactionHistory);
        }
        //删除线索的备注
        clueRemarkMapper.deleteClueRemarkByClueId(clueId);
        //删除线索和市场活动的关联关系
        clueActivityRelationMapper.deleteCARByClueId(clueId);
        //删除线索
        clueMapper.deleteClueById(clueId);
    }
}
