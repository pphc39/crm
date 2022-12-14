package com.xauat.workbench.mapper;

import com.xauat.workbench.pojo.Transaction;

import java.util.List;
import java.util.Map;

public interface TransactionMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_transaction
     *
     * @mbggenerated Thu Jun 30 09:55:43 CST 2022
     */
    int deleteByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_transaction
     *
     * @mbggenerated Thu Jun 30 09:55:43 CST 2022
     */
    int insert(Transaction record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_transaction
     *
     * @mbggenerated Thu Jun 30 09:55:43 CST 2022
     */
    int insertSelective(Transaction record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_transaction
     *
     * @mbggenerated Thu Jun 30 09:55:43 CST 2022
     */
    Transaction selectByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_transaction
     *
     * @mbggenerated Thu Jun 30 09:55:43 CST 2022
     */
    int updateByPrimaryKeySelective(Transaction record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_transaction
     *
     * @mbggenerated Thu Jun 30 09:55:43 CST 2022
     */
    int updateByPrimaryKey(Transaction record);

    int insertTransaction(Transaction transaction);

    List<Transaction> selectTransactionByConditionsForPage(Map<String, Object> map);

    int selectTransactionCountByConditions(Map<String, Object> map);

    Transaction selectTransactionDetailById(String id);

    int deleteTransactionByIds(String[] ids);

    Transaction selectTransactionForEditById(String id);

    int updateTransaction(Transaction transaction);
}
