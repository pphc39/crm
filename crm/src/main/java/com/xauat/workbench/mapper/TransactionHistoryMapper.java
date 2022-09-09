package com.xauat.workbench.mapper;

import com.xauat.workbench.pojo.TransactionHistory;

import java.util.List;

public interface TransactionHistoryMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_transaction_history
     *
     * @mbggenerated Thu Jul 07 13:54:05 CST 2022
     */
    int deleteByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_transaction_history
     *
     * @mbggenerated Thu Jul 07 13:54:05 CST 2022
     */
    int insert(TransactionHistory record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_transaction_history
     *
     * @mbggenerated Thu Jul 07 13:54:05 CST 2022
     */
    int insertSelective(TransactionHistory record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_transaction_history
     *
     * @mbggenerated Thu Jul 07 13:54:05 CST 2022
     */
    TransactionHistory selectByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_transaction_history
     *
     * @mbggenerated Thu Jul 07 13:54:05 CST 2022
     */
    int updateByPrimaryKeySelective(TransactionHistory record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_transaction_history
     *
     * @mbggenerated Thu Jul 07 13:54:05 CST 2022
     */
    int updateByPrimaryKey(TransactionHistory record);

    int insertTransactionHistory(TransactionHistory transactionHistory);

    List<TransactionHistory> selectTransactionHistoryByTransactionId(String transactionId);

    int deleteTransactionHistoryByTransactionIds(String[] transactionIds);
}
