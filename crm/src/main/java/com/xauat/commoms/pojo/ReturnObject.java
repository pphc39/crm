package com.xauat.commoms.pojo;

public class ReturnObject {
    private String flag;
    private String message;
    private Object returnData;

    public void setFlag(String flag) {
        this.flag = flag;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public String getFlag() {
        return flag;
    }

    public String getMessage() {
        return message;
    }

    public Object getReturnData() {
        return returnData;
    }

    public void setReturnData(Object returnData) {
        this.returnData = returnData;
    }
}
