
import React, { useState } from 'react';
import { InputProps } from '../types';
import { EyeIcon } from './Icons';

const CustomInput: React.FC<InputProps> = ({ 
  label, 
  placeholder, 
  type = "text", 
  icon, 
  value, 
  onChange,
  isPassword = false 
}) => {
  const [showPassword, setShowPassword] = useState(false);

  const togglePassword = () => {
    setShowPassword(!showPassword);
  };

  const actualType = isPassword ? (showPassword ? 'text' : 'password') : type;

  return (
    <div className="w-full flex flex-col gap-2 mb-6">
      <label className="text-gray-700 text-sm font-semibold pr-1">
        {label}
      </label>
      <div className="relative flex items-center">
        <input
          type={actualType}
          value={value}
          onChange={(e) => onChange(e.target.value)}
          placeholder={placeholder}
          className="w-full h-[64px] bg-gray-50 border border-gray-100 rounded-xl px-5 text-gray-800 focus:outline-none focus:ring-2 focus:ring-[#d4af37]/20 focus:border-[#d4af37] transition-all placeholder:text-gray-300 placeholder:font-light"
        />
        {/* Icons are usually on the left in this specific Arabic mockup's style */}
        {icon && !isPassword && (
          <div className="absolute left-4 text-gray-400">
            {icon}
          </div>
        )}
        {isPassword && (
          <button 
            type="button" 
            onClick={togglePassword}
            className="absolute left-4 text-gray-400 hover:text-gray-600 transition-colors"
          >
            <EyeIcon className="w-5 h-5" />
          </button>
        )}
      </div>
    </div>
  );
};

export default CustomInput;
