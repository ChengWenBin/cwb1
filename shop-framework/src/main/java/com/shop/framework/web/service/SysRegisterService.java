package com.shop.framework.web.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import com.shop.common.constant.CacheConstants;
import com.shop.common.constant.Constants;
import com.shop.common.constant.UserConstants;
import com.shop.common.core.domain.entity.SysUser;
import com.shop.common.core.domain.model.RegisterBody;
import com.shop.common.core.redis.RedisCache;
import com.shop.common.exception.user.CaptchaException;
import com.shop.common.exception.user.CaptchaExpireException;
import com.shop.common.utils.MessageUtils;
import com.shop.common.utils.SecurityUtils;
import com.shop.common.utils.StringUtils;
import com.shop.framework.manager.AsyncManager;
import com.shop.framework.manager.factory.AsyncFactory;
import com.shop.system.service.ISysConfigService;
import com.shop.system.service.ISysUserService;

/**
 * 注册校验方法
 * 
 * @author ruoyi
 */
@Component
public class SysRegisterService
{
    @Autowired
    private ISysUserService userService;

    @Autowired
    private ISysConfigService configService;

    @Autowired
    private RedisCache redisCache;

    /**
     * 注册
     */
    public String register(RegisterBody registerBody)
    {
        String msg = "", username = registerBody.getUsername(), password = registerBody.getPassword();
        SysUser sysUser = new SysUser();
        sysUser.setUserName(username);

        // 验证码开关
        boolean captchaEnabled = configService.selectCaptchaEnabled();
        if (captchaEnabled)
        {
            validateCaptcha(username, registerBody.getCode(), registerBody.getUuid());
        }

        if (StringUtils.isEmpty(username))
        {
            msg = "用户名不能为空";
        }
        else if (StringUtils.isEmpty(password))
        {
            msg = "用户密码不能为空";
        }
        else if (username.length() < UserConstants.USERNAME_MIN_LENGTH
                || username.length() > UserConstants.USERNAME_MAX_LENGTH)
        {
            msg = "账户长度必须在2到20个字符之间";
        }
        else if (password.length() < UserConstants.PASSWORD_MIN_LENGTH
                || password.length() > UserConstants.PASSWORD_MAX_LENGTH)
        {
            msg = "密码长度必须在5到20个字符之间";
        }
        else if (!userService.checkUserNameUnique(sysUser))
        {
            msg = "保存用户'" + username + "'失败，注册账号已存在";
        }
        else
        {
            sysUser.setNickName(username);
            sysUser.setPassword(SecurityUtils.encryptPassword(password));
            boolean regFlag = userService.registerUser(sysUser);
            if (!regFlag)
            {
                msg = "注册失败,请联系系统管理人员";
            }
            else
            {
                AsyncManager.me().execute(AsyncFactory.recordLogininfor(username, Constants.REGISTER, MessageUtils.message("user.register.success")));
                
                try
                {
                    // 获取默认角色ID，如果没有配置，默认使用2号角色(假设2为普通用户角色)
                    String defaultRoleId = configService.selectConfigByKey("sys.user.default.role");
                    defaultRoleId = StringUtils.isEmpty(defaultRoleId) ? "2" : defaultRoleId;
                    
                    // 设置用户角色
                    Long[] roleIds = {Long.valueOf(defaultRoleId)};
                    userService.insertUserAuth(sysUser.getUserId(), roleIds);
                }
                catch (Exception e)
                {
                    // 记录日志但不影响注册流程
                    AsyncManager.me().execute(AsyncFactory.recordLogininfor(username, Constants.REGISTER, 
                            "用户注册成功，但分配默认角色失败: " + e.getMessage()));
                }
            }
        }
        return msg;
    }

    /**
     * 校验验证码
     * 
     * @param username 用户名
     * @param code 验证码
     * @param uuid 唯一标识
     * @return 结果
     */
    public void validateCaptcha(String username, String code, String uuid)
    {
        String verifyKey = CacheConstants.CAPTCHA_CODE_KEY + StringUtils.nvl(uuid, "");
        String captcha = redisCache.getCacheObject(verifyKey);
        redisCache.deleteObject(verifyKey);
        if (captcha == null)
        {
            throw new CaptchaExpireException();
        }
        if (!code.equalsIgnoreCase(captcha))
        {
            throw new CaptchaException();
        }
    }
}
